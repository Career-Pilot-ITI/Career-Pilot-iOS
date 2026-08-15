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

    /// The completed result, extracted for easy access by the results screen.
    var completedResult: CvOptimizationResult? {
        if case .completed(let result) = state { return result }
        return nil
    }

    // MARK: - Dependencies

    private let triggerUseCase: TriggerCvOptimizeUseCase
    private let pollUseCase: PollCvOptimizeJobUseCase

    // MARK: - Polling internals

    private var pollingTask: Task<Void, Never>?
    private var lastProgressChangeDate: Date = Date()
    private var lastKnownPercentage: Int = 0

    /// Configuration
    private let pollInterval: UInt64 = 2_000_000_000   // 2 seconds in nanoseconds
    private let maxPollCount: Int = 90                  // ~3 minutes
    private let stillWorkingThreshold: TimeInterval = 12 // seconds

    // MARK: - Init

    init(
        triggerUseCase: TriggerCvOptimizeUseCase,
        pollUseCase: PollCvOptimizeJobUseCase
    ) {
        self.triggerUseCase = triggerUseCase
        self.pollUseCase = pollUseCase
    }

    // MARK: - Public Actions

    /// Kicks off the optimize job using the workspace ID from the current job
    /// and begins polling for progress.
    func startOptimize(workspaceId: Int) async {
        // Cancel any existing polling
        cancelPolling()

        // Reset state
        state = .starting
        displayedProgress = 0
        showStillWorking = false
        lastKnownPercentage = 0
        lastProgressChangeDate = Date()

        do {
            // Trigger the job
            let initialJob = try await triggerUseCase.execute(workspaceId)
            let jobId = initialJob.id

            // Check if already completed (unlikely but possible)
            if initialJob.status == .completed, let result = initialJob.result {
                animateProgress(to: 100)
                state = .completed(result)
                return
            }

            if initialJob.status == .failed {
                state = .failed(
                    message: initialJob.errorMessage
                        ?? "Something went wrong — your coins have been refunded."
                )
                return
            }

            // Update initial progress
            updateProgress(initialJob)

            // Start polling loop
            pollingTask = Task { [weak self] in
                await self?.pollLoop(workspaceId: workspaceId, jobId: jobId)
            }

        } catch {
            state = .failed(
                message: "Couldn't start CV optimization. Please check your connection and try again."
            )
        }
    }

    /// Cancels any active polling task.
    func cancelPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    /// Retries by re-triggering the optimize job from scratch.
    func retry(workspaceId: Int) async {
        await startOptimize(workspaceId: workspaceId)
    }

    // MARK: - Polling Loop

    private func pollLoop(workspaceId: Int, jobId: Int) async {
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
                let job = try await pollUseCase.execute(
                    PollJobInput(workspaceId: workspaceId, jobId: jobId)
                )

                switch job.status {
                case .completed:
                    if let result = job.result {
                        animateProgress(to: 100)
                        // Small delay so the user sees 100% before transitioning
                        try? await Task.sleep(nanoseconds: 800_000_000)
                        guard !Task.isCancelled else { return }
                        state = .completed(result)
                    } else {
                        state = .failed(
                            message: "Optimization completed but results were empty. Please try again."
                        )
                    }
                    return

                case .failed:
                    state = .failed(
                        message: job.errorMessage
                            ?? "Something went wrong — your coins have been refunded."
                    )
                    return

                case .pending, .processing, .unknown:
                    updateProgress(job)
                }

            } catch {
                // Network error during polling — don't fail immediately, just log
                print("CvOptimize: Poll error at iteration \(iteration): \(error)")
                // Continue polling — transient network errors shouldn't kill the loop
            }

            // Check "still working" threshold
            checkStillWorking()
        }

        // Max polls exceeded
        if !Task.isCancelled {
            state = .timeout
        }
    }

    // MARK: - Progress Helpers

    private func updateProgress(_ job: AiJobEntity) {
        let newPercentage = job.progressPercentage

        if newPercentage != lastKnownPercentage {
            lastKnownPercentage = newPercentage
            lastProgressChangeDate = Date()
            showStillWorking = false
        }

        state = .inProgress(percentage: newPercentage, step: job.currentStep)
        animateProgress(to: newPercentage)
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
