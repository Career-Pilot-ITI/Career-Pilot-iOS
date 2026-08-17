//
//  ToastView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import SwiftUI

struct ToastView: View {
    let toast: ToastMessage

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.type.icon)
                .foregroundColor(toast.type.color)
            Text(toast.text)
                .font(.size14Regular)
                .foregroundColor(.white)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(toast.type.color.opacity(0.92))
        )
        .shadow(radius: 8)
        .padding(.horizontal, 24)
    }
}

struct ToastModifier: ViewModifier {
    @ObservedObject var toastManager: ToastManager

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast = toastManager.currentToast {
                    ToastView(toast: toast)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: toastManager.currentToast)
                }
            }
    }
}

extension View {
    func toast(_ toastManager: ToastManager) -> some View {
        modifier(ToastModifier(toastManager: toastManager))
    }
}
