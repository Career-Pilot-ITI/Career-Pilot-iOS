//
//  PermissionManager.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 26/07/2026.
//

import AVFoundation

/// Which system permission is being checked/requested.
enum AppPermission {
    case microphone
    case camera
}

/// Normalized status across AVAudioSession's and AVCaptureDevice's differently-shaped
/// permission enums, so callers deal with one type regardless of which permission it is.
enum AppPermissionStatus {
    case granted
    case denied
    case notDetermined

    var isGranted: Bool { self == .granted }

    fileprivate init(_ status: AVAudioSession.RecordPermission) {
        switch status {
        case .granted: self = .granted
        case .denied: self = .denied
        case .undetermined: self = .notDetermined
        @unknown default: self = .denied
        }
    }

    fileprivate init(_ status: AVAuthorizationStatus) {
        switch status {
        case .authorized: self = .granted
        case .denied, .restricted: self = .denied
        case .notDetermined: self = .notDetermined
        @unknown default: self = .denied
        }
    }
}

protocol PermissionManaging {
    func status(for permission: AppPermission) -> AppPermissionStatus
    func requestPermission(for permission: AppPermission, completion: @escaping (Bool) -> Void)
}

final class PermissionManager: PermissionManaging {

    func status(for permission: AppPermission) -> AppPermissionStatus {
        switch permission {
        case .microphone:
            return AppPermissionStatus(AVAudioSession.sharedInstance().recordPermission)
        case .camera:
            return AppPermissionStatus(AVCaptureDevice.authorizationStatus(for: .video))
        }
    }

    func requestPermission(for permission: AppPermission, completion: @escaping (Bool) -> Void) {
        switch permission {
        case .microphone:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        }
    }
}
