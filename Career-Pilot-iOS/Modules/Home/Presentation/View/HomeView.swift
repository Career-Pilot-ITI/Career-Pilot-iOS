//
//  HomeView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            ZStack {
                // Main Content
                VStack(spacing: 20) {
                    CustomNavigationBar(userName: viewModel.userName, userScore: viewModel.userScore)
                    
                    SubscriptionCard(usedSessions: viewModel.usedSessions, totalSessions: viewModel.totalSessions)
                    
                    ProgressCard(
                        score: 88,
                        progressLabel: "Good Progress",
                        scoreChange: "▲ +6 from last week"
                    )
                    
                    PracticeCard(category: "SOFTWARE ENGINEERING")
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Recent Sessions").font(.headline)
                            Spacer()
                            Text("See all").foregroundColor(.orange)
                        }
                        
                        ForEach(viewModel.recentSessions) { session in
                            SessionRow(score: session.score, title: session.title, time: session.time)
                        }
                    }
                }
                .padding()
                .opacity(viewModel.isLoading ? 0 : 1)
                
                if viewModel.isLoading {
                    ShimmerLoadingView()
                        .transition(.opacity.animation(.easeInOut))
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HomeView()
}
