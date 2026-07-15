//
//  PulsingIconBadge.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
//

import SwiftUI

struct PulsingIconBadge: View {

    let icon: String

    var tint: Color?

    var size: CGFloat = 140

    var state: WaitingIndicatorState = .loading

    @State private var isPulsing = false
    @State private var didShake = false
    @State private var iconScale: CGFloat = 0.7

    private var resolvedTint: Color {
        tint ?? state.defaultTint
    }

    var body: some View {

        ZStack {

            if state.isAnimating {

                ForEach(0..<2) { i in

                    Circle()
                        .fill(resolvedTint.opacity(0.15))
                        .frame(width: size, height: size)
                        .scaleEffect(isPulsing ? 1.15 : 0.9)
                        .opacity(isPulsing ? 0 : 0.6)
                        .animation(
                            .easeOut(duration: state.pulseDuration)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * (state.pulseDuration / 2.8)),
                            value: isPulsing
                        )
                }
            }

            Circle()
                .fill(resolvedTint.opacity(0.18))
                .frame(width: size, height: size)

            Circle()
                .strokeBorder(
                    resolvedTint.opacity(0.6),
                    lineWidth: 1
                )
                .frame(
                    width: size * 0.72,
                    height: size * 0.72
                )

            if state == .listening || state == .recording {

                WaveformBars(
                    tint: resolvedTint,
                    isAnimating: state.isAnimating
                )
                .frame(
                    width: size * 0.34,
                    height: size * 0.24
                )

            } else {

                Image(systemName: icon)
                    .font(
                        .system(
                            size: state == .success
                                ? size * 0.32
                                : size * 0.24,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(resolvedTint)
                    .scaleEffect(iconScale)
            }

            if state == .recording {

                Circle()
                    .fill(.red)
                    .frame(
                        width: size * 0.09,
                        height: size * 0.09
                    )
                    .opacity(isPulsing ? 0.3 : 1)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                    .offset(
                        x: size * 0.32,
                        y: -size * 0.32
                    )
            }
        }
        .frame(
            width: size * 1.3,
            height: size * 1.3
        )
        .modifier(
            ShakeEffect(
                shakes: state == .failure && didShake ? 2 : 0
            )
        )
        .onAppear {

            isPulsing = state.isAnimating

            if state == .success {

                withAnimation(
                    .spring(
                        response: 0.45,
                        dampingFraction: 0.55
                    )
                ) {
                    iconScale = 1
                }
            }

            if state == .failure {

                withAnimation(.default.delay(0.1)) {
                    didShake = true
                }
            }
        }
    }
}
