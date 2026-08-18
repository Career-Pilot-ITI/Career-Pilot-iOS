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
                SubscriptionCard {
                    coordinator.push(.subscribtion)
                }

                // MARK: - Progress
                if let progressInfo = viewModel.progressInfo {
                    ProgressCard(info: progressInfo)
                }
                // MARK: - Practice
                PracticeCard(category: viewModel.trackName) {
                    coordinator.push(
                        .interviewPrep(
                            trackName: viewModel.trackName,
                            trackId: viewModel.user.profile.trackId,
                            interviewType: .classic
                        )
                    )
                }

                // MARK: - ATS
                ATSCard(
                    iconName: "target",
                    title: "ATS Job Match",
                    badgeText: "NEW",
                    subtitle: "Paste a job link · See how your CV scores",
                    accentColor: .primaryTeal,
                    action: {
                        viewModel.onAtsClick()
//                        coordinator.push(.atsJobMatch)   // whatever case your HomeRoute enum defines

                    }
                )

                // MARK: - Recommended Interviews

                if !viewModel.recommendedInterviews.isEmpty {
                    recommendedInterviewsSection
                }
                
                // MARK: - Recent Sessions

                if !viewModel.recentSessions.isEmpty {
                    recentSessionsSection
                }
               
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s12)
        }
        .onAppear{
            viewModel.onAppear(coordinator: coordinator)
        }
        .fancyAlert(
            isPresented: $viewModel.showSubscriptionRequiredAlert,
            icon: "crown.fill",
            title: "Upgrade Required",
            message: viewModel.subscriptionRequiredMessage,
            buttons: [
                FancyAlertButton(title: "Subscription Screen", style: .primary) {
                    viewModel.subscriptionAlertHomeTapped()
                },
                FancyAlertButton(title: "Cancel", style: .secondary) {
                    viewModel.subscriptionAlertCancelTapped()
                }
            ]
        )
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
            switch viewModel.tracksState {
                case .idle, .loading ,.success:
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
                case .error(_) :
                    EmptyView()
                    
            }
          

            switch viewModel.tracksState {

            case .idle, .loading:
                recommendedInterviewsSkeleton

            case .success:
                recommendedInterviewsContent

            case .error(_):
                errorView(message: "Some Thing Went Wrong")
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
                        action: {
                            print("Tapped on \(track.title)")
                            coordinator.push(.interviewPrep(
                                    trackName: track.title,
                                    trackId: track.trackInterview.track.id,
                                    interviewType: .classic
                                )
                            )
                        }
                    )
                    .onTapGesture {
                        print("Tapped on \(track.title)")
                        coordinator.push(.interviewPrep(
                                trackName: track.title,
                                trackId: track.trackInterview.track.id,
                                interviewType: .classic
                            )
                        )
                    }
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
            
            switch viewModel.tracksState {
                case .idle, .loading ,.success:
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
                case .error(_) :
                    EmptyView()
                    
            }

            switch viewModel.sessionsState {

            case .idle, .loading:
                recentSessionsSkeleton

            case .success:
                recentSessionsContent

            case .error(_):
                errorView(message: "Some Thing Went Wrong")
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
                        coordinator.push(.sessionDetail(sessionId: session.id))
                    }
                ).onTapGesture{
                    
                    print("Tapped on \(session.title)")
                    coordinator.push(.sessionDetail(sessionId: session.id))
                }
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
