////
////  Waitingstateview.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 15/07/2026.
////
//
//import SwiftUI
//
//// MARK: - WaitingIndicatorState
//// Drives animation speed, default tint, and whether the badge animates at all.
//
//enum WaitingIndicatorState {
//    case loading
//    case listening
//    case recording
//    case success
//    case failure
//
//    var isAnimating: Bool {
//        self != .failure
//    }
//
//    var pulseDuration: Double {
//        switch self {
//        case .loading: return 1.4
//        case .listening: return 1.9
//        case .recording: return 0.85
//        case .success: return 1.8
//        case .failure: return 0
//        }
//    }
//
//    var defaultTint: Color {
//        switch self {
//        case .loading: return .teal
//        case .listening: return .blue
//        case .recording: return .red
//        case .success: return .successColour
//        case .failure: return .errorColour
//        }
//    }
//}
//
//// MARK: - PulsingIconBadge
//// The animated circle + icon piece. Reusable anywhere: pass any SF Symbol + color + state.
//
//struct PulsingIconBadge: View {
//    let icon: String
//    var tint: Color? = nil
//    var size: CGFloat = 140
//    var state: WaitingIndicatorState = .loading
//
//    @State private var isPulsing = false
//    @State private var didShake = false
//
//    private var resolvedTint: Color {
//        tint ?? state.defaultTint
//    }
//
//    var body: some View {
//        ZStack {
//            if state.isAnimating {
//                ForEach(0..<2) { i in
//                    Circle()
//                        .fill(resolvedTint.opacity(0.15))
//                        .frame(width: size, height: size)
//                        .scaleEffect(isPulsing ? 1.15 : 0.9)
//                        .opacity(isPulsing ? 0.0 : 0.6)
//                        .animation(
//                            .easeOut(duration: state.pulseDuration)
//                                .repeatForever(autoreverses: false)
//                                .delay(Double(i) * (state.pulseDuration / 2.8)),
//                            value: isPulsing
//                        )
//                }
//            }
//
//            // Static solid background circle
//            Circle()
//                .fill(resolvedTint.opacity(0.18))
//                .frame(width: size, height: size)
//
//            // Thin outlined inner circle
//            Circle()
//                .strokeBorder(resolvedTint.opacity(0.6), lineWidth: 1)
//                .frame(width: size * 0.72, height: size * 0.72)
//
//            // Icon, or waveform for listening/recording
//            if state == .listening || state == .recording {
//                WaveformBars(tint: resolvedTint, isAnimating: state.isAnimating)
//                    .frame(width: size * 0.34, height: size * 0.24)
//            } else {
//                Image(systemName: icon)
//                    .font(.system(size: size * 0.24, weight: .medium))
//                    .foregroundStyle(resolvedTint)
//            }
//
//            // Small blinking dot badge for active recording
//            if state == .recording {
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: size * 0.09, height: size * 0.09)
//                    .opacity(isPulsing ? 0.3 : 1.0)
//                    .animation(
//                        .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
//                        value: isPulsing
//                    )
//                    .offset(x: size * 0.32, y: -size * 0.32)
//            }
//        }
//        .frame(width: size * 1.3, height: size * 1.3)
//        .rotationEffect(.degrees(didShake ? 0 : 0))
//        .modifier(ShakeEffect(shakes: state == .failure && didShake ? 2 : 0))
//        .onAppear {
//            isPulsing = state.isAnimating
//            if state == .failure {
//                withAnimation(.default.delay(0.1)) { didShake = true }
//            }
//        }
//        .onChange(of: state) { newState in
//            isPulsing = newState.isAnimating
//            didShake = false
//            if newState == .failure {
//                withAnimation(.default.delay(0.1)) { didShake = true }
//            }
//        }
//    }
//}
//
//
//private struct WaveformBars: View {
//    let tint: Color
//    let isAnimating: Bool
//
//    @State private var animate = false
//
//    private let barCount = 5
//
//    var body: some View {
//        HStack(spacing: 4) {
//            ForEach(0..<barCount, id: \.self) { i in
//                RoundedRectangle(cornerRadius: 2)
//                    .fill(tint)
//                    .frame(width: 4, height: animate ? heights[i] : 8)
//                    .animation(
//                        .easeInOut(duration: 0.5)
//                            .repeatForever(autoreverses: true)
//                            .delay(Double(i) * 0.12),
//                        value: animate
//                    )
//            }
//        }
//        .onAppear { animate = isAnimating }
//    }
//
//    private var heights: [CGFloat] { [14, 24, 32, 20, 12] }
//}
//
//
//private struct ShakeEffect: GeometryEffect {
//    var shakes: CGFloat
//    var animatableData: CGFloat {
//        get { shakes }
//        set { shakes = newValue }
//    }
//
//    func effectValue(size: CGSize) -> ProjectionTransform {
//        let translation = 6 * sin(shakes * .pi * 4)
//        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
//    }
//}
//
//struct WaitingStateView: View {
//    let icon: String
//    var tint: Color? = nil
//    var state: WaitingIndicatorState = .loading
//    let title: String
//    var subtitle: String? = nil
//    var actionTitle: String? = nil
//    var action: (() -> Void)? = nil
//
//    var body: some View {
//        VStack(spacing: 28) {
//            PulsingIconBadge(icon: icon, tint: tint, state: state)
//
//            VStack(spacing: 8) {
//                Text(title)
//                    .font(.title2.bold())
//                    .foregroundStyle(.white)
//                    .multilineTextAlignment(.center)
//
//                if let subtitle {
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundStyle(.white.opacity(0.6))
//                        .multilineTextAlignment(.center)
//                }
//            }
//
//            if state == .failure, let actionTitle, let action {
//                Button(action: action) {
//                    Text(actionTitle)
//                        .font(.headline)
//                        .foregroundStyle(.white)
//                        .padding(.horizontal, 28)
//                        .padding(.vertical, 12)
//                        .background(Capsule().fill((tint ?? state.defaultTint)))
//                }
//                .padding(.top, 4)
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(red: 0.06, green: 0.08, blue: 0.14).ignoresSafeArea())
//    }
//}
//
//// MARK: - Example usages across different screens
//
//struct SuccessPaymentScreen: View {
//    var body: some View {
//        WaitingStateView(
//            icon: "checkmark.fill",
//            state: .success,
//            title: "Payment Successful!",
//            subtitle: "Your transaction was completed successfully. Welcome to Plus."
//        )
//    }
//}
//
//
//struct CallingWaitingScreen: View {
//    var body: some View {
//        WaitingStateView(
//            icon: "phone.fill",
//            state: .loading,
//            title: "Calling...",
//            subtitle: "Please wait while we connect you"
//        )
//    }
//}
//
//struct UploadingWaitingScreen: View {
//    var body: some View {
//        WaitingStateView(
//            icon: "arrow.up.circle.fill",
//            tint: .blue,
//            state: .loading,
//            title: "Uploading files",
//            subtitle: "This might take a moment"
//        )
//    }
//}
//
//struct ListeningWaitingScreen: View {
//    var body: some View {
//        WaitingStateView(
//            icon: "mic.fill",
//            state: .listening,
//            title: "Listening...",
//            subtitle: "Go ahead, we're picking up your voice"
//        )
//    }
//}
//
//struct RecordingWaitingScreen: View {
//    var body: some View {
//        WaitingStateView(
//            icon: "mic.fill",
//            state: .recording,
//            title: "Recording",
//            subtitle: "Tap stop when you're done"
//        )
//    }
//}
//
//struct FailureWaitingScreen: View {
//    var body: some View {
//        WaitingStateView(
//            icon: "exclamationmark.triangle.fill",
//            state: .failure,
//            title: "Something went wrong",
//            subtitle: "We couldn't complete your request",
//            actionTitle: "Try Again",
//            action: { print("retry tapped") }
//        )
//    }
//}
//
//#Preview("payment") {
//    SuccessPaymentScreen()
//}
//
//#Preview("Calling") {
//    CallingWaitingScreen()
//}
//
//#Preview("Uploading") {
//    UploadingWaitingScreen()
//}
//
//#Preview("Listening") {
//    ListeningWaitingScreen()
//}
//
//#Preview("Recording") {
//    RecordingWaitingScreen()
//}
//
//#Preview("Failure") {
//    FailureWaitingScreen()
//}
