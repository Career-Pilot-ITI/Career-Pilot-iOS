//
//  CvOptimizeProgressView.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import SwiftUI

struct CvOptimizeProgressView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @EnvironmentObject var atsViewModel: ATSViewModel
    @EnvironmentObject var viewModel: CvOptimizeViewModel

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            switch viewModel.state {
            case .idle, .starting:
                progressView(step: nil)

            case .inProgress(_, let step):
                progressView(step: step)

            case .completed:
                completedTransitionView

            case .failed(let message):
                failedView(message: message)

            case .timeout:
                timeoutView
            }
        }
        .navigationTitle("CV Optimize")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Reset transient state on fresh entry so .task starts a new optimization.
            // hasCompletedInSession is true only when returning from results (onDisappear
            // did not fire because we pushed, not popped). In that case, skip the reset
            // to avoid auto-push loop. When entering fresh from parent, onDisappear
            // cleared the flag, so we reset and start a new optimization.
            if viewModel.hasCompletedInSession { return }
            viewModel.state = .idle
            viewModel.displayedProgress = 0
            viewModel.showStillWorking = false
        }
        .task {
            print("I came here hi in the loading")
            guard viewModel.state == .idle || viewModel.state == .timeout else {return }
            if let workspaceId = atsViewModel.currentJob?.workspaceID {
                await viewModel.startOptimize(workspaceId: workspaceId)
            }
        }
        .onDisappear {
            print("I've cancelled the polling")
            viewModel.cancelPolling()
            viewModel.clearCompletedFlag()
        }
        .onChange(of: viewModel.state) { newState in
            if case .completed = newState {
                coordinator.push(.cvOptimizeResults)
            }
        }
        .operationGuard(
            isOperationActive: Binding(
                get: {
                    switch viewModel.state {
                    case .starting, .inProgress: return true
                    default: return false
                    }
                },
                set: { _ in }
            ),
            onCancel: {
                viewModel.cancelPolling()
            }
        )
    }

    // MARK: - Progress

    private func progressView(step: String?) -> some View {
        VStack(spacing: 32) {
            Spacer()

            // Animated progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray200, lineWidth: 10)
                    .frame(width: 160, height: 160)

                Circle()
                    .trim(from: 0, to: viewModel.displayedProgress / 100.0)
                    .stroke(
                        Color.primary,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: viewModel.displayedProgress)

                if let step {
                    Text("\(Int(viewModel.displayedProgress))%")
                        .font(Font.size32Bold)
                        .foregroundStyle(Color.textPrimary)
                        .contentTransition(.numericText())
                } else {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(Color.primary)
                }
            }

            // Step text with crossfade
            VStack(spacing: 8) {
                if let step {
                    Text(step)
                        .font(Font.size16Medium)
                        .multilineTextAlignment(.center)
                        .id(step)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.easeInOut(duration: 0.5), value: step)
                } else {
                    Text("Starting CV optimization…")
                        .font(Font.size16Medium)
                        .foregroundStyle(Color.textSecondary)
                }

                if viewModel.showStillWorking {
                    Text("Still working on it — this can take a minute…")
                        .font(Font.size13Regular)
                        .foregroundStyle(Color.textTertiary)
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.6), value: viewModel.showStillWorking)
                }
            }
            .padding(.horizontal, Spacing.s24)

            Spacer()
            Spacer()
        }
    }

    // MARK: - Completed (brief transition before nav push)

    private var completedTransitionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.matchGreen)

            Text("Optimization complete!")
                .font(Font.size18Bold)
                .foregroundStyle(Color.textPrimary)
        }
    }

    // MARK: - Failed

    private func failedView(message: String) -> some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.matchRed)

            Text("Optimization Failed")
                .font(Font.size20Bold)

            Text(message)
                .font(Font.size14Regular)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.s32)

            // Refund notice
            HStack(spacing: 6) {
                Image(systemName: "arrow.uturn.backward.circle")
                    .foregroundStyle(Color.matchGreen)
                Text("Your coins have been refunded automatically.")
                    .font(Font.size13Medium)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(.horizontal, Spacing.s20)

            Spacer()

            CustomButton(
                isButtonEnabeld: true,
                showArrow: false,
                buttonTitle: "Try Again",
                onClick: {
                    Task {
                        if let workspaceId = atsViewModel.currentJob?.workspaceID {
                            await viewModel.retry(workspaceId: workspaceId)
                        }
                    }
                }
            )
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s24)
        }
    }

    // MARK: - Timeout

    private var timeoutView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "clock.badge.exclamationmark")
                .font(.system(size: 48))
                .foregroundStyle(Color.matchAmber)

            Text("Taking Longer Than Expected")
                .font(Font.size20Bold)

            Text("The optimization is still running on our servers. Please try again in a moment.")
                .font(Font.size14Regular)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.s32)

            Spacer()

            CustomButton(
                isButtonEnabeld: true,
                showArrow: false,
                buttonTitle: "Retry",
                onClick: {
                    Task {
                        if let workspaceId = atsViewModel.currentJob?.workspaceID {
                            await viewModel.retry(workspaceId: workspaceId)
                        }
                    }
                }
            )
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s24)
        }
    }
}
//
//#Preview {
//    CvOptimizeProgressView()
//}
