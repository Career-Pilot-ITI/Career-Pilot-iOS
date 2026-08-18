//
//  OperationGuardModifier.swift
//  Career-Pilot-iOS
//
//  A reusable view modifier that prevents accidental back navigation
//  while a long-running operation is in progress.
//

import SwiftUI

// MARK: - Modifier

struct OperationGuardModifier: ViewModifier {
    @Binding var isOperationActive: Bool
    var onCancel: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var showLeaveAlert = false

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
            .alert("Operation in Progress", isPresented: $showLeaveAlert) {
                Button("Stay", role: .cancel) {}
                Button("Leave", role: .destructive) {
                    onCancel?()
                    dismiss()
                }
            } message: {
                Text("Your request is still being processed. If you leave now, the operation will be cancelled.")
            }
    }

    private var backButton: some View {
        Button {
            if isOperationActive {
                showLeaveAlert = true
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - View Extension

extension View {
    /// Guards against accidental back navigation while an operation is active.
    ///
    /// When `isOperationActive` is `true`, tapping the back button shows a
    /// confirmation dialog. The user can choose to stay (operation continues)
    /// or leave (the `onCancel` closure is called and the view is dismissed).
    ///
    /// When `isOperationActive` is `false`, the back button navigates normally.
    ///
    /// - Parameters:
    ///   - isOperationActive: Binding to a flag indicating whether a
    ///     protected operation is currently running.
    ///   - onCancel: Optional closure called when the user chooses to leave.
    ///     Use this to cancel tasks, invalidate state, or clean up resources.
    func operationGuard(
        isOperationActive: Binding<Bool>,
        onCancel: (() -> Void)? = nil
    ) -> some View {
        modifier(OperationGuardModifier(
            isOperationActive: isOperationActive,
            onCancel: onCancel
        ))
    }
}
