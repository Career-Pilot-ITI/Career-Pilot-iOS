//
//  HomeView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct HomeView: View {
    let usedSessions: Double = 1.0
    let totalSessions: Double = 3.0
    let recentSessions: [SessionData] = [
            SessionData(score: 82, title: "Software Eng.", time: "Today, 2:14 PM · 18 min"),
            SessionData(score: 74, title: "Software Eng.", time: "Yesterday, 10:30 AM · 22 min"),
            SessionData(score: 68, title: "System Design", time: "Mon, 9:00 AM · 15 min"),
            SessionData(score: 82, title: "Software Eng.", time: "Today, 2:14 PM · 18 min"),
            SessionData(score: 74, title: "Software Eng.", time: "Yesterday, 10:30 AM · 22 min"),
            SessionData(score: 68, title: "System Design", time: "Mon, 9:00 AM · 15 min")
        ]
    var body: some View {

        ScrollView {
            VStack(spacing: 20) {
                CustomNavigationBar(userName: "Ahmed El-Sayyad Mohamed",userScore:150)
                
                
                SubscriptionCard(usedSessions: usedSessions, totalSessions: totalSessions)
                ProgressCard(
                    score: 88,
                    progressLabel: "Good Progress",
                    scoreChange: "▲ +6 from last week",
                )
                PracticeCard(
                    category: "SOFTWARE ENGINEERING"
                )
                VStack {
                    HStack { Text("Recent Sessions").font(.headline); Spacer(); Text("See all").foregroundColor(.orange) }
                    
                    ForEach(recentSessions) { session in
                        SessionRow(
                            score: session.score,
                            title: session.title,
                            time: session.time
                        )
                    }
                }
            }
            .padding()
            }
            .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HomeView()
}
