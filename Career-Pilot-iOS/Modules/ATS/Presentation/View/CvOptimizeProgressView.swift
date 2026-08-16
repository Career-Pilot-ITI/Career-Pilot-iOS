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
                startingView

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
            // Reset state when entering the progress screen fresh
            // (e.g., user tapped "Apply Suggested Edits" again)
            if case .completed = viewModel.state {
                viewModel.state = .idle
                viewModel.displayedProgress = 0
            }
        }
        .task {
            guard viewModel.state == .idle || viewModel.state == .timeout else { return }
            if let workspaceId = atsViewModel.currentJob?.workspaceID {
                await viewModel.startOptimize(workspaceId: workspaceId)
            }
        }
        .onDisappear {
            viewModel.cancelPolling()
        }
        .onChange(of: viewModel.state) { newState in
            if case .completed = newState {
                coordinator.push(.cvOptimizeResults)
            }
        }
    }

    // MARK: - Starting

    private var startingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color.primary)

            Text("Starting CV optimization…")
                .font(Font.size16Medium)
                .foregroundStyle(Color.textSecondary)
        }
    }

    // MARK: - In Progress

    private func progressView(step: String) -> some View {
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

                Text("\(Int(viewModel.displayedProgress))%")
                    .font(Font.size32Bold)
                    .foregroundStyle(Color.textPrimary)
                    .contentTransition(.numericText())
            }

            // Step text with crossfade
            VStack(spacing: 8) {
                Text(step)
                    .font(Font.size16Medium)
                    .multilineTextAlignment(.center)
                    .id(step)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeInOut(duration: 0.5), value: step)

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

#Preview {
    CvOptimizeProgressView()
}
