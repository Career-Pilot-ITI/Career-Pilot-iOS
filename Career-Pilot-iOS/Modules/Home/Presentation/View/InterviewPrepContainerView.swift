//
//  InterviewPrepContainerView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import SwiftUI
import UIKit
struct InterviewPrepContainerView: View {

    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var viewModel =
        DIContainer.shared.container.resolve(InterviewPrepViewModel.self)!

    let trackName: String
    let trackId: Int
    let interviewType: InterviewType

    var body: some View {

        PracticePreparationView(
            categoryText: trackName,
            metadataText: "\(interviewType.interviewConfiguration.maxQuestions) Questions · ~\(interviewType.interviewConfiguration.maxInterviewDuration) min",
            title: "Ready to practice?",
            subtitle: "Before we begin, a few quick tips.",
            tips: [
                PracticeTip(stepNumber: "1", text: "Find a quiet space with minimal background noise"),
                PracticeTip(stepNumber: "2", text: "Speak clearly and at a natural pace"),
                PracticeTip(stepNumber: "3", text: "Take time to gather your thoughts before answering"),
                PracticeTip(stepNumber: "4", text: "The AI will wait for you to finish before responding")
            ],
            selectedMode: $viewModel.selectedMode,
            isMicrophoneGranted: Binding(
                get: { viewModel.microphoneEnabled },
                set: { viewModel.microphoneToggleChanged($0) }
            ),
            isCameraGranted: Binding(
                get: { viewModel.cameraEnabled },
                set: { viewModel.cameraToggleChanged($0) }
            ),
            accentColor: .primary,
            onCancel: { coordinator.pop() },
            onBegin: { beginInterview() }
        )
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.onAppear(initialMode: interviewType.interviewConfiguration.mode)
        }
        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }
            viewModel.refreshScreenPermissions()
        }
        .alert(
            "Permission Required",
            isPresented: $viewModel.showSettingsAlert
        ) {
            Button("Settings") { openSettings() }
            Button("Cancel", role: .cancel) { viewModel.refreshScreenPermissions() }
        } message: {
            Text(viewModel.settingsAlertMessage)
        }
        .confirmationDialog(
            "Disable permission?",
            isPresented: $viewModel.showOpenSettingsConfirmation,
            titleVisibility: .visible
        ) {
            Button("Open Settings") { openSettings() }
            Button("Cancel", role: .cancel) { viewModel.refreshScreenPermissions() }
        } message: {
            Text(viewModel.disableConfirmationMessage)
        }
    }

    private func beginInterview() {
        coordinator.push(
            .practiceInterview(
                trackName: trackName,
                trackId: trackId,
                interviewType: resolvedInterviewType()
            )
        )
    }

    private func resolvedInterviewType() -> InterviewType {
        let config = interviewType.interviewConfiguration
        return .custom(
            mode: viewModel.selectedMode,
            maxQuestions: config.maxQuestions,
            maxAnswerDuration: config.maxAnswerDuration,
            maxInterviewDuration: config.maxInterviewDuration
        )
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}
