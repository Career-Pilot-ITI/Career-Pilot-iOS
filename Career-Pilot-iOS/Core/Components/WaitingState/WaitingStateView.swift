import SwiftUI

struct WaitingStateView: View {

    let icon: String
    var tint: Color?
    var state: WaitingIndicatorState = .loading

    let title: String

    var subtitle: String?

    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {

        VStack(spacing: 28) {

            PulsingIconBadge(
                icon: icon,
                tint: tint,
                state: state
            )

            VStack(spacing: 8) {

                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                if let subtitle {

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
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
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        .background(
            Color(red: 0.06,
                  green: 0.08,
                  blue: 0.14)
                .ignoresSafeArea()
        )
    }
}
