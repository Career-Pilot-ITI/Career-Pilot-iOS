//
//  CvOptimizeViewModel.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation
import SwiftUI

// MARK: - State

enum CvOptimizeState: Equatable {
    case idle
    case starting
    case inProgress(percentage: Int, step: String)
    case completed(CvOptimizationResult)
    case failed(message: String)
    case timeout

    static func == (lhs: CvOptimizeState, rhs: CvOptimizeState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.starting, .starting),
             (.timeout, .timeout):
            return true
        case (.inProgress(let lp, let ls), .inProgress(let rp, let rs)):
            return lp == rp && ls == rs
        case (.failed(let lm), .failed(let rm)):
            return lm == rm
        case (.completed, .completed):
            return true
        default:
            return false
        }
    }
}

// MARK: - ViewModel

@MainActor
class CvOptimizeViewModel: ObservableObject {

    // MARK: - Published State

    @Published var state: CvOptimizeState = .idle
    @Published var displayedProgress: Double = 0
    @Published var showStillWorking: Bool = false

    /// Tracks whether optimization has completed in the current session.
    /// Used by the view to distinguish "returning from results" (skip reset)
    /// from "fresh entry from parent" (reset and start new optimization).
    private(set) var hasCompletedInSession: Bool = false

    /// The completed result, extracted for easy access by the results screen.
    var completedResult: CvOptimizationResult? {
        if case .completed(let result) = state { return result }
        return nil
    }

    // MARK: - Dependencies

    private let triggerUseCase: TriggerCvOptimizeUseCase
    private let pollUseCase: PollCvOptimizeUseCase
    private let toastManager: ToastManager

    // MARK: - Polling internals

    private var pollingTask: Task<Void, Never>?
    private var lastProgressChangeDate: Date = Date()
    private var lastKnownPercentage: Int = 0

    /// Configuration
    private let pollInterval: UInt64
    private let maxPollCount: Int
    private let stillWorkingThreshold: TimeInterval
    private let completionDelay: UInt64

    // MARK: - Init

    init(
        triggerUseCase: TriggerCvOptimizeUseCase,
        pollUseCase: PollCvOptimizeUseCase,
        toastManager: ToastManager,
        pollInterval: UInt64 = 2_000_000_000,
        maxPollCount: Int = 90,
        stillWorkingThreshold: TimeInterval = 12,
        completionDelay: UInt64 = 800_000_000
    ) {
        self.triggerUseCase = triggerUseCase
        self.pollUseCase = pollUseCase
        self.toastManager = toastManager
        self.pollInterval = pollInterval
        self.maxPollCount = maxPollCount
        self.stillWorkingThreshold = stillWorkingThreshold
        self.completionDelay = completionDelay
    }

    // MARK: - Public Actions

    /// Kicks off the optimize job using the workspace ID from the current job
    /// and begins polling for progress.
    func startOptimize(workspaceId: Int) async {
        // Cancel any existing polling
        cancelPolling()

        // Reset state
        hasCompletedInSession = false
        state = .starting
        displayedProgress = 0
        showStillWorking = false
        lastKnownPercentage = 0
        lastProgressChangeDate = Date()

        do {
            // Trigger the job
            let initialResponse = try await triggerUseCase.execute(workspaceId)

            if initialResponse.status == .failed {
                let message = initialResponse.errorMessage
                    ?? "Something went wrong — your coins have been refunded."
                state = .failed(message: message)
                toastManager.show(message, type: .error)
                return
            }

            if initialResponse.status == .completed || initialResponse.progressPercentage >= 100 {
                await complete(with: initialResponse)
                return
            }

            // Update initial progress
            updateProgress(initialResponse)

            // The backend uses this same POST endpoint for both starting and polling.
            pollingTask = Task { [weak self] in
                await self?.pollLoop(workspaceId: workspaceId)
            }

        } catch {
            let message = "Couldn't start CV optimization. Please check your connection and try again."
            state = .failed(message: message)
            toastManager.show(message, type: .error)
        }
    }

    /// Cancels any active polling task.
    func cancelPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    /// Clears the completion flag when navigating away from the progress screen.
    /// Called from onDisappear when the view is popped (not when pushing to results).
    func clearCompletedFlag() {
        hasCompletedInSession = false
    }

    /// Retries by re-triggering the optimize job from scratch.
    func retry(workspaceId: Int) async {
        await startOptimize(workspaceId: workspaceId)
    }

    // MARK: - Polling Loop

    private func pollLoop(workspaceId: Int) async {
        for iteration in 0..<maxPollCount {
            // Check cancellation
            guard !Task.isCancelled else {
                print("CvOptimize: Polling cancelled at iteration \(iteration)")
                return
            }

            // Wait between polls
            do {
                try await Task.sleep(nanoseconds: pollInterval)
            } catch {
                // Task was cancelled during sleep
                return
            }

            guard !Task.isCancelled else { return }

            // Poll the status
            do {
                let response = try await pollUseCase.execute(workspaceId)

                if response.status == .failed {
                    let message = response.errorMessage
                        ?? "Something went wrong — your coins have been refunded."
                    state = .failed(message: message)
                    toastManager.show(message, type: .error)
                    return
                }

                if response.status == .completed || response.progressPercentage >= 100 {
                    await complete(with: response)
                    return
                }

                updateProgress(response)

            } catch {
                print("CvOptimize: Poll error at iteration \(iteration): \(error)")
                guard isRetryable(error) else {
                    let message = errorMessage(for: error)
                    state = .failed(message: message)
                    toastManager.show(message, type: .error)
                    return
                }
            }

            // Check "still working" threshold
            checkStillWorking()
        }

        // Max polls exceeded
        if !Task.isCancelled {
            state = .timeout
            toastManager.show("Optimization is taking longer than expected. Please try again.", type: .error)
        }
    }

    // MARK: - Progress Helpers

    private func updateProgress(_ response: CvOptimizeResponse) {
        let newPercentage = min(max(response.progressPercentage, 0), 100)

        if newPercentage != lastKnownPercentage {
            lastKnownPercentage = newPercentage
            lastProgressChangeDate = Date()
            showStillWorking = false
        }

        state = .inProgress(percentage: newPercentage, step: response.currentStep)
        animateProgress(to: newPercentage)
    }

    private func complete(with response: CvOptimizeResponse) async {
        guard let result = response.result else {
            let message = "Optimization completed but results were empty. Please try again."
            state = .failed(message: message)
            toastManager.show(message, type: .error)
            return
        }

        animateProgress(to: 100)
        try? await Task.sleep(nanoseconds: completionDelay)
        guard !Task.isCancelled else { return }
        hasCompletedInSession = true
        state = .completed(result)
    }

    private func isRetryable(_ error: Error) -> Bool {
        (error as? NetworkError)?.isRetryable ?? false
    }

    private func errorMessage(for error: Error) -> String {
        (error as? NetworkError)?.userMessage
            ?? "Couldn't continue CV optimization. Please try again."
    }

    private func animateProgress(to target: Int) {
        withAnimation(.easeInOut(duration: 1.0)) {
            displayedProgress = Double(target)
        }
    }

    private func checkStillWorking() {
        let elapsed = Date().timeIntervalSince(lastProgressChangeDate)
        if elapsed >= stillWorkingThreshold && !showStillWorking {
            showStillWorking = true
        }
    }
}
