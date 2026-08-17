//
//  HomeView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel =
        DIContainer.shared.container.resolve(HomeViewModel.self)!

    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    var onSeeAllSessionsTapped: (() -> Void)?
    
    private let cardColors: [Color] = [
        .orange,
        .blue,
        .purple,
        .green,
        .pink,
        .teal
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.s20) {

                // MARK: - User / Header
                userSection

                // MARK: - Subscription
                SubscriptionCard(
                    usedSessions: viewModel.usedSessions,
                    totalSessions: viewModel.totalSessions
                )

                // MARK: - Progress
                if let progressInfo = viewModel.progressInfo {
                    ProgressCard(info: progressInfo)
                }
                // MARK: - Practice
                PracticeCard(
                    category: "SOFTWARE ENGINEERING",
                    onStartInterview: {
                        coordinator.push(
                            .interviewPrep(
                                trackName: "SOFTWARE ENGINEERING",
                                trackId: viewModel.user.profile.trackId,
                                interviewType: .classic
                            )
                        )
                    },
                    onStartQuiz:{
                        coordinator.push(
                                .pathLearn(
                                    trackId: String(viewModel.user.profile.trackId),
                                    trackName: "SOFTWARE ENGINEERING"
                                )
                        )
                    } 
                )

                // MARK: - ATS
                ATSCard(
                    iconName: "scope",
                    title: "ATS Job Match",
                    badgeText: "NEW",
                    subtitle: "Paste a job link · See how your CV scores",
                    accentColor: .primaryTeal,
                    action: {
                        // Navigate to ATS
                        print("go to ats")
                    }
                )

                // MARK: - Recommended Interviews
                recommendedInterviewsSection

                // MARK: - Recent Sessions
                recentSessionsSection
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s12)
        }
        .scrollIndicators(.hidden)
        .background(Color.background.ignoresSafeArea())
        .task {
            await viewModel.loadHome()
        }
        .refreshable {
            await viewModel.loadHome()
        }
    }
}

// MARK: - User Section

private extension HomeView {

    @ViewBuilder
    var userSection: some View {
        switch viewModel.userState {

        case .idle, .loading:
            ShimmerLoadingView()

        case .success:
            CustomNavigationBar(
                userName: viewModel.user.profile.displayName,
                userScore: viewModel.user.profile.coinBalance
            )

        case .error:
            CustomNavigationBar(
                userName: "Guest",
                userScore: 0
            )
        }
    }
}

// MARK: - Recommended Interviews

private extension HomeView {

    @ViewBuilder
    var recommendedInterviewsSection: some View {

        VStack(spacing: Spacing.s12) {

            HStack {
                Text("Recommended For You")
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Button {
                    coordinator.push(.InterviewsView)
                } label: {
                    Text("See all")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.accentColor)
                }
            }

            switch viewModel.tracksState {

            case .idle, .loading:
                recommendedInterviewsSkeleton

            case .success:
                recommendedInterviewsContent

            case .error(let message):
                errorView(message: message)
            }
        }
    }

    var recommendedInterviewsSkeleton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.s16) {
                ForEach(0..<3, id: \.self) { _ in
                    CareerCardSkeletonView()
                }
            }
        }
    }
    var recommendedInterviewsContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.s16) {
                
                ForEach(
                    Array(viewModel.recommendedInterviews.enumerated()),
                    id: \.offset
                ) { index, track in

                    let assignedColor = cardColors[index % cardColors.count]

                    CareerCardView(
                        iconName: track.iconName,
                        title: track.title,
                        tagText: track.tagText,
                        durationText: track.durationText,
                        accentColor: assignedColor,
                        onStartInterview: {
                            coordinator.push(
                                .interviewPrep(
                                    trackName: track.title,
                                    trackId: track.trackInterview.track.id,
                                    interviewType: .custom(
                                        mode: .audio,
                                        maxQuestions: track.level.duration/10,
                                        maxAnswerDuration: 3,
                                        maxInterviewDuration: TimeInterval(track.level.duration),
                                    )
                                )
                            )
                        },
                        onStartQuiz: {
                            coordinator.push(
                                .pathLearn(
                                    trackId: String(track.trackInterview.track.id),
                                    trackName: track.title
                                )
                            )
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Recent Sessions

private extension HomeView {

    @ViewBuilder
    var recentSessionsSection: some View {

        VStack(spacing: Spacing.s12) {

            HStack {
                Text("Recent Sessions")
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Button {
                    // Navigate to all recent sessions
                    print("See all recent sessions")
                    onSeeAllSessionsTapped?()
                } label: {
                    Text("See all")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.accentColor)
                }
            }

            switch viewModel.sessionsState {

            case .idle, .loading:
                recentSessionsSkeleton

            case .success:
                recentSessionsContent

            case .error(let message):
                errorView(message: message)
            }
        }
    }

    var recentSessionsSkeleton: some View {
        VStack(spacing: Spacing.s12) {
            ForEach(0..<3, id: \.self) { _ in
                SessionRowSkeleton()
            }
        }
    }

    var recentSessionsContent: some View {
        VStack(spacing: Spacing.s12) {

            ForEach(
                Array(viewModel.recentSessions.enumerated()),
                id: \.offset
            ) { index, session in

                let assignedColor = cardColors[index % cardColors.count]

                SessionRow(
                    score: session.score,
                    title: session.title,
                    time: session.time,
                    iconColor: assignedColor,
                    action: {
                        print("Tapped on \(session.title)")
                    }
                )
            }
        }
    }
}

// MARK: - Error View

private extension HomeView {

    func errorView(message: String) -> some View {
        VStack(spacing: Spacing.s8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.red)

            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.s16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(Radius.r12)
    }
}

// MARK: - Preview
//
//#Preview {
//    let viewModel =
//        DIContainer.shared.container.resolve(HomeViewModel.self)!
//
//    return HomeView()
//        .environmentObject(AppCoordinator<HomeRoute>())
//        .task {
//            await viewModel.loadHome()
//        }
//}
