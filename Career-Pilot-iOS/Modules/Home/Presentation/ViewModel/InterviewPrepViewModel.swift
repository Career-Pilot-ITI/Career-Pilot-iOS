//
//  InterviewPrepViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//

import Foundation

@MainActor
final class InterviewPrepViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var microphoneEnabled = false
    @Published var showSettingsAlert = false
    @Published var showOpenSettingsConfirmation = false

    // MARK: - Dependencies

    private let permissionManager: MicrophonePermissionManaging

    // MARK: - Initialization

    init(
        permissionManager: MicrophonePermissionManaging
    ) {
        self.permissionManager = permissionManager
    }

    // MARK: - Lifecycle

    func onAppear() {
        refreshMicrophonePermission()
    }

    // MARK: - Permission

    func refreshMicrophonePermission() {
        microphoneEnabled =
            permissionManager.permissionStatus() == .granted
    }

    func microphoneToggleChanged(_ enabled: Bool) {

        if enabled {
            handleMicrophoneEnable()
        } else {
            handleMicrophoneDisable()
        }
    }

    private func handleMicrophoneEnable() {

        switch permissionManager.permissionStatus() {

        case .granted:
            microphoneEnabled = true

        case .undetermined:

            permissionManager.requestPermission { [weak self] granted in
                guard let self else { return }

                Task { @MainActor in
                    self.microphoneEnabled = granted

                    if !granted {
                        self.showSettingsAlert = true
                    }
                }
            }

        case .denied:
            microphoneEnabled = false
            showSettingsAlert = true

        @unknown default:
            microphoneEnabled = false
        }
    }

    private func handleMicrophoneDisable() {

        // iOS doesn't allow disabling an individual permission
        // programmatically. The user must change it from Settings.
        showOpenSettingsConfirmation = true

        // Keep the UI switch enabled until the user confirms.
        microphoneEnabled = true
    }
}
