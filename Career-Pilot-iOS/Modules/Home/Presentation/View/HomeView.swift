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
    
    let cardColors: [Color] = [.orange, .blue, .purple, .green, .pink, .teal]
    let assignedColor  = Color.blue
    
    var body: some View {
        Group {
            if let user = viewModel.user {
                content(user)
            } else {
                ShimmerLoadingView()
            }
        }
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.loadUser()
            viewModel.loadData()
        }
    }

    @ViewBuilder
    private func content(_ user: User) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                CustomNavigationBar(
                    userName: user.profile.displayName,
                    userScore: user.profile.coinBalance
                )

                SubscriptionCard(
                    usedSessions: viewModel.usedSessions,
                    totalSessions: viewModel.totalSessions
                )
                ProgressCard(
                    score: 88,
                    progressLabel: "Good Progress",
                    scoreChange: "▲ +6 from last week"
                )

                PracticeCard(category: "SoftWare Engineering"){
                    print("👉 PracticeCard tapped! Pushing route...")
                    
                    coordinator.push(.interviewPrep(
                            trackName: "SoftWare Engineering",
                            trackId: viewModel.user.profile.trackId,
                            interviewType: .Classic
                        ))
                }
                HStack {
                    Text("Recommended For You")
                        .font(.headline)
                    Spacer()
                    Text("See all")
                        .foregroundColor(.orange)
                }


                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.s16) {
                        if viewModel.isLoading {
                            ForEach(0..<3, id: \.self) { _ in
                                CareerCardSkeletonView()
                            }
                        } else {
                            ForEach(Array(viewModel.mockCareerItems.enumerated()), id: \.offset) { index, item in
                                let assignedColor = cardColors[index % cardColors.count]
                                
                                CareerCardView(
                                    iconName: item.iconName,
                                    title: item.title,
                                    tagText: item.tagText,
                                    durationText: item.durationText,
                                    accentColor: assignedColor,
                                    action: {
                                        print("Tapped on \(item.title)")
                                    }
                                )
                            }
                        }
                    }
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Recent Sessions")
                            .font(.headline)
                        Spacer()
                        Text("See all")
                            .foregroundColor(.orange)
                    }

                    if viewModel.isLoading {
                            ForEach(0..<3, id: \.self) { _ in
                                SessionRowSkeleton()
                            }
                        } else {
                            ForEach(Array(viewModel.recentSessions.enumerated()), id: \.offset) { index, session in
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
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}
