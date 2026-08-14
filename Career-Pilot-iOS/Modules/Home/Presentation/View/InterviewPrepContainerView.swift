//
//  InterviewPrepContainerView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import SwiftUI
import UIKit

struct InterviewPrepContainerView: View {

    // MARK: - Environment

    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>

    @Environment(\.scenePhase)
    private var scenePhase

    // MARK: - ViewModel

    @StateObject private var viewModel =
        DIContainer.shared.container.resolve(InterviewPrepViewModel.self)!

    // MARK: - Properties

    let trackName: String
    let trackId: Int
    let interviewType: InterviewType

    // MARK: - Body

    var body: some View {

        PracticePreparationView(
            categoryText: trackName,
            metadataText: "\(interviewType.interviewConfiguration.maxQuestions) Questions · ~\(interviewType.interviewConfiguration.maxInterviewDuration) min",
            title: "Ready to practice?",
            subtitle: "Before we begin, a few quick tips.",
            tips: [
                PracticeTip(
                    stepNumber: "1",
                    text: "Find a quiet space with minimal background noise"
                ),
                PracticeTip(
                    stepNumber: "2",
                    text: "Speak clearly and at a natural pace"
                ),
                PracticeTip(
                    stepNumber: "3",
                    text: "Take time to gather your thoughts before answering"
                ),
                PracticeTip(
                    stepNumber: "4",
                    text: "The AI will wait for you to finish before responding"
                )
            ],
            isMicrophoneGranted: $viewModel.microphoneEnabled,
            accentColor: .primary,
            onCancel: {
                coordinator.pop()
            },
            onBegin: {
                beginInterview()
            }
        )
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)

        // MARK: - Lifecycle

        .onAppear {
            viewModel.onAppear()
        }

        // MARK: - Microphone Toggle

        .onChange(of: viewModel.microphoneEnabled) { isEnabled in
            viewModel.microphoneToggleChanged(isEnabled)
        }

        // MARK: - App Lifecycle

        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }

            viewModel.refreshMicrophonePermission()
        }

        // MARK: - Permission Alert

        .alert(
            "Microphone Permission Required",
            isPresented: $viewModel.showSettingsAlert
        ) {
            Button("Settings") {
                openSettings()
            }

            Button("Cancel", role: .cancel) {
                viewModel.refreshMicrophonePermission()
            }
        } message: {
            Text(
                "Please enable microphone access in Settings to continue."
            )
        }

        // MARK: - Disable Microphone Dialog

        .confirmationDialog(
            "Disable microphone permission?",
            isPresented: $viewModel.showOpenSettingsConfirmation,
            titleVisibility: .visible
        ) {
            Button("Open Settings") {
                openSettings()
            }

            Button("Cancel", role: .cancel) {
                viewModel.refreshMicrophonePermission()
            }
        } message: {
            Text(
                "Microphone permission can only be disabled from the Settings app."
            )
        }
    }

    // MARK: - Actions

    private func beginInterview() {
        print("Begin interview tapped")

        coordinator.push(
            .practiceInterview(
                trackName: trackName,
                trackId: trackId,
                interviewType: interviewType
            )
        )
    }

    private func openSettings() {
        guard let url = URL(
            string: UIApplication.openSettingsURLString
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }
}
