//
//  InterviewPrepContainerView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//
import SwiftUI

struct InterviewPrepContainerView: View {

    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>

    @StateObject
    private var viewModel =
        DIContainer.shared.container.resolve(HomeViewModel.self)!

    @Environment(\.scenePhase)
    private var scenePhase

    let trackName: String
    let interviewTime: Int
    let quetionsCount: Int

    var body: some View {

        PracticePreparationView(
            categoryText: trackName,
            metadataText: "\(quetionsCount) Questions · ~\(interviewTime) min",
            title: "Ready to practice?",
            subtitle: "Before we begin, a few quick tips.",
            tips: [
                PracticeTip(stepNumber: "1", text: "Find a quiet space with minimal background noise"),
                PracticeTip(stepNumber: "2", text: "Speak clearly and at a natural pace"),
                PracticeTip(stepNumber: "3", text: "Take time to gather your thoughts before answering"),
                PracticeTip(stepNumber: "4", text: "The AI will wait for you to finish before responding")
            ],
            isMicrophoneGranted: $viewModel.microphoneEnabled,
            accentColor: .orange,
            onCancel: {
                coordinator.pop()
            },
            onBegin: {
                print("Begin interview tapped")
            }
        )
        .navigationBarHidden(true)

        .onAppear {
            viewModel.onAppear()
        }

        .onChange(of: viewModel.microphoneEnabled) { isOn in
            viewModel.microphoneToggleChanged(isOn)
        }

        .onChange(of: scenePhase) { phase in
            if phase == .active {
                viewModel.refreshMicrophonePermission()
            }
        }

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
            Text("Please enable microphone access in Settings to continue.")
        }

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
            Text("Microphone permission can only be disabled from the Settings app.")
        }
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(url)
    }
}
#Preview {
    InterviewPrepContainerView(trackName: "SoftWare Engineering", interviewTime: 30, quetionsCount: 8)
}
