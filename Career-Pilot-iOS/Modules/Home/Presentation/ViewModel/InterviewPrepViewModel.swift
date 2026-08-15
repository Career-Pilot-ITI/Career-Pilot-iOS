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
    @Published var cameraEnabled = false

    @Published var showSettingsAlert = false
    @Published var showOpenSettingsConfirmation = false

    @Published var selectedMode: InterviewMode = .audio

    private var pendingPermission: AppPermission = .microphone

    // MARK: - Dependencies

    private let permissionManager: PermissionManaging

    // MARK: - Initialization

    init(permissionManager: PermissionManaging) {
        self.permissionManager = permissionManager
    }

    // MARK: - Lifecycle

    func onAppear(initialMode: InterviewMode) {
        selectedMode = initialMode
        refreshScreenPermissions()
    }

    func refreshScreenPermissions() {
        microphoneEnabled = permissionManager.status(for: .microphone).isGranted
        cameraEnabled = permissionManager.status(for: .camera).isGranted
    }

    // MARK: - Toggle entry points
    // Called directly from a custom Binding's `set` — NOT from .onChange —
    // so setEnabled()'s own writes below never re-trigger this method.

    func microphoneToggleChanged(_ enabled: Bool) {
        enabled ? handleEnable(.microphone) : handleDisable(.microphone)
    }

    func cameraToggleChanged(_ enabled: Bool) {
        enabled ? handleEnable(.camera) : handleDisable(.camera)
    }

    // MARK: - Shared permission flow

    private func handleEnable(_ permission: AppPermission) {
        switch permissionManager.status(for: permission) {
        case .granted:
            setEnabled(true, for: permission)

        case .notDetermined:
            permissionManager.requestPermission(for: permission) { [weak self] granted in
                guard let self else { return }
                Task { @MainActor in
                    self.setEnabled(granted, for: permission)
                    if !granted {
                        self.presentSettingsAlert(for: permission)
                    }
                }
            }

        case .denied:
            setEnabled(false, for: permission)
            presentSettingsAlert(for: permission)
        }
    }

    private func handleDisable(_ permission: AppPermission) {
        // iOS doesn't allow disabling an individual permission
        // programmatically. The user must change it from Settings.
        // Keep the UI switch showing "on" until the user confirms.
        setEnabled(true, for: permission)
        presentDisableConfirmation(for: permission)
    }

    private func setEnabled(_ enabled: Bool, for permission: AppPermission) {
        switch permission {
        case .microphone: microphoneEnabled = enabled
        case .camera: cameraEnabled = enabled
        }
    }

    // MARK: - Modal presentation (mutually exclusive by construction)

    private func presentSettingsAlert(for permission: AppPermission) {
        pendingPermission = permission
        showOpenSettingsConfirmation = false
        showSettingsAlert = true
    }

    private func presentDisableConfirmation(for permission: AppPermission) {
        pendingPermission = permission
        showSettingsAlert = false
        showOpenSettingsConfirmation = true
    }

    // MARK: - Alert/dialog copy, permission-aware

    var pendingPermissionIsCamera: Bool {
        pendingPermission == .camera
    }

    var settingsAlertMessage: String {
        pendingPermissionIsCamera
            ? "Please enable camera access in Settings to continue."
            : "Please enable microphone access in Settings to continue."
    }

    var disableConfirmationMessage: String {
        pendingPermissionIsCamera
            ? "Camera permission can only be disabled from the Settings app."
            : "Microphone permission can only be disabled from the Settings app."
    }
}
