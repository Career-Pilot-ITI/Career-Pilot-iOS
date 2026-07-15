//
//  WaitingIndicatorState.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI

enum WaitingIndicatorState {
    case loading
    case listening
    case recording
    case success
    case failure

    var isAnimating: Bool {
        switch self {
        case .loading, .listening, .recording:
            return true
        case .success, .failure:
            return false
        }
    }

    var pulseDuration: Double {
        switch self {
        case .loading:
            return 1.4

        case .listening:
            return 1.9

        case .recording:
            return 0.85

        case .success,
             .failure:
            return 0
        }
    }

    var defaultTint: Color {
        switch self {
        case .loading:
            return .teal

        case .listening:
            return .blue

        case .recording:
            return .red

        case .success:
            return .successColour

        case .failure:
            return .errorColour
        }
    }
}
