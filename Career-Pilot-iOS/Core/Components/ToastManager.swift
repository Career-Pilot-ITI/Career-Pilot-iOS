//
//  ToastManager.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import SwiftUI

enum ToastType {
    case error
    case success
    case info

    var color: Color {
        switch self {
        case .error: return .red
        case .success: return .green
        case .info: return .blue
        }
    }

    var icon: String {
        switch self {
        case .error: return "exclamationmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

struct ToastMessage: Equatable {
    let id = UUID()
    let text: String
    let type: ToastType

    static func == (lhs: ToastMessage, rhs: ToastMessage) -> Bool {
        lhs.id == rhs.id
    }
}

@MainActor
final class ToastManager: ObservableObject {
    static let shared = ToastManager()
    @Published var currentToast: ToastMessage?
    private var dismissTask: Task<Void, Never>?

    func show(_ text: String, type: ToastType = .error, duration: TimeInterval = 3.5) {
        dismissTask?.cancel()   // cancel any pending dismiss from a previous toast

        let toast = ToastMessage(text: text, type: type)
        currentToast = toast

        dismissTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            if currentToast?.id == toast.id {
                currentToast = nil
            }
        }
    }
}
