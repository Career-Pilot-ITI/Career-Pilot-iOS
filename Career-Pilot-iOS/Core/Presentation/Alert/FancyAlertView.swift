//
//  FancyAlertView.swift
//  Career-Pilot-iOS
//
//  A reusable, custom-styled alert to use in place of the native .alert()
//  wherever the flow deserves more visual weight than a system dialog
//  (upsells, celebratory confirmations, destructive actions, etc).
//

import SwiftUI

struct FancyAlertButton {
    enum Style {
        case primary
        case secondary
    }

    let title: String
    let style: Style
    let action: () -> Void
}

struct FancyAlertView: View {
    let icon: String
    let iconTint: Color
    let title: String
    let message: String
    let buttons: [FancyAlertButton]

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconTint.opacity(0.12))
                    .frame(width: 64, height: 64)
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(iconTint)
            }
            .padding(.top, Spacing.s16)

            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray400)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, Spacing.s16)

            VStack(spacing: 10) {
                ForEach(Array(buttons.enumerated()), id: \.offset) { _, button in
                    Button(action: button.action) {
                        Text(button.title)
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: Radius.r16)
                            .fill(button.style == .primary ? Color.primaryTeal : Color.clear)
                    )
                    .foregroundColor(button.style == .primary ? .white : Color.primaryTeal)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.r16)
                            .stroke(button.style == .secondary ? Color.primaryTeal.opacity(0.35) : .clear, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.bottom, Spacing.s16)
        }
        .frame(maxWidth: 320)
        .background(
            RoundedRectangle(cornerRadius: Radius.r16 * 1.5)
                .fill(Color.darkBackGround)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r16 * 1.5)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 30, y: 10)
    }
}

// MARK: - Presentation modifier

private struct FancyAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let icon: String
    let iconTint: Color
    let title: String
    let message: String
    let buttons: [FancyAlertButton]

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    // Swallow taps so they don't fall through to content behind —
                    // dismissal only happens via the alert's own buttons.
                    .onTapGesture {}

                FancyAlertView(
                    icon: icon,
                    iconTint: iconTint,
                    title: title,
                    message: message,
                    buttons: buttons
                )
                .transition(.scale(scale: 0.85).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.82), value: isPresented)
    }
}

extension View {
    /// A custom-styled alternative to `.alert()`. Use for moments that deserve more
    /// visual weight (upsells, celebratory confirmations) — for routine system
    /// confirmations, the native `.alert()` is still the right, more accessible choice.
    func fancyAlert(
        isPresented: Binding<Bool>,
        icon: String,
        iconTint: Color = Color.primaryTeal,
        title: String,
        message: String,
        buttons: [FancyAlertButton]
    ) -> some View {
        modifier(
            FancyAlertModifier(
                isPresented: isPresented,
                icon: icon,
                iconTint: iconTint,
                title: title,
                message: message,
                buttons: buttons
            )
        )
    }
}

///EXAMPLE How can you use
//.fancyAlert(
//isPresented: $viewModel.showSubscriptionRequiredAlert,
//icon: "crown.fill",
//title: "Upgrade Required",
//message: viewModel.subscriptionRequiredMessage,
//buttons: [
//    FancyAlertButton(title: "Subscription Screen", style: .primary) {
//        viewModel.subscriptionAlertHomeTapped()
//    },
//    FancyAlertButton(title: "Cancel", style: .secondary) {
//        viewModel.subscriptionAlertCancelTapped()
//    }
//]
//)
/// like a normal alert
