//
//  VideoCaptureError.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//

import Foundation

enum VideoCaptureError: LocalizedError {
    case permissionDenied
    case cameraUnavailable
    case sessionConfigurationFailed(String)
    case sessionInterrupted(String)

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Camera access was not granted."
        case .cameraUnavailable:
            return "The front camera is unavailable on this device."
        case .sessionConfigurationFailed(let reason):
            return "Could not configure the camera session: \(reason)"
        case .sessionInterrupted(let reason):
            return "Camera session was interrupted: \(reason)"
        }
    }
}
