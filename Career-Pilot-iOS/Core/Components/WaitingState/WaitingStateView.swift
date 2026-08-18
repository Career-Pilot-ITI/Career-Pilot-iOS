import SwiftUI

struct WaitingStateView: View {

    let icon: String
    var tint: Color?
    var state: WaitingIndicatorState = .loading

    let title: String

    var subtitle: String?

    var actionTitle: String?
    var action: (() -> Void)?
    var phoneNumber: String?

    var body: some View {

        VStack(spacing: 16) {

            PulsingIconBadge(
                icon: icon,
                tint: tint,
                state: state
            )

            VStack(spacing: 8) {

                Text(title)
                    .font(.title2.bold())

                if let subtitle {

                    VStack(spacing: Spacing.s8) {
                        Text(subtitle)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        if let phoneNumber {
                            Text(phoneNumber)
                                .font(.size14Semibold)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }

            if state == .failure,
               let actionTitle,
               let action {

                Button(actionTitle) {
                    action()
                }
                .buttonStyle(.borderedProminent)
                .tint(tint ?? state.defaultTint)
            }
        }
        .padding()
    }
}
