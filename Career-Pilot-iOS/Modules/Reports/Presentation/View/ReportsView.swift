//
//  ReportsView.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import SwiftUI

struct ReportsView: View {
    @StateObject private var coordinator = AppCoordinator<ReportsRoute>()
    @State private var metrics: [RadarMetric] = [
        RadarMetric(label: "Clarity", value: 78, color: .orange),
        RadarMetric(label: "Confidence", value: 85, color: .green),
        RadarMetric(label: "Pacing", value: 72, color: .orange),
        RadarMetric(label: "Filler Words", value: 65, color: .orange),
        RadarMetric(label: "Content", value: 90, color: .green)
    ]
    @State private var suggestions: [CoachingSuggestion] = [
        CoachingSuggestion(
            icon: "target",
            text: "Reduce filler words",
            description: "You used 'um' and 'uh' 14 times. Try pausing silently instead.",
            badgeLevel: "High impact"
        ),
        CoachingSuggestion(
            icon: "target",
            text: "Slow down your pace",
            description: "Your speaking pace was a bit fast in the second half of the answer.",
            badgeLevel: "Medium impact"
        ),
        CoachingSuggestion(
            icon: "target",
            text: "Add more structure",
            description: "Try using a clear beginning, middle, and end for your answers.",
            badgeLevel: "Low impact"
        )
    ]
    @State private var sessions: [Session] = [
        Session(title: "Software Engineering", score: 82, noOfQuestions: 8, perioudTime: "18m", date: "Today"),
        Session(title: "Software Engineering", score: 74, noOfQuestions: 8, perioudTime: "22m", date: "Yesterday"),
        Session(title: "System Design", score: 68, noOfQuestions: 6, perioudTime: "15m", date: "Mon 8 Jul"),
        Session(title: "Software Engineering", score: 79, noOfQuestions: 8, perioudTime: "20m", date: "Sat 6 Jul"),
        Session(title: "Behavioural", score: 85, noOfQuestions: 10, perioudTime: "25m", date: "Thu 4 Jul"),
        Session(title: "Software Engineering", score: 71, noOfQuestions: 8, perioudTime: "18m", date: "Mon 1 Jul")
    ]

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            SessionHistory(
                sessionCount: sessions.count,
                sessionAvgScore: sessions.map(\.score).reduce(0, +) / Double(max(sessions.count, 1)),
                sessions: sessions
            )
            .navigationDestination(for: ReportsRoute.self) { route in
                destination(for: route)
            }
        }
        .environmentObject(coordinator)
    }

    @ViewBuilder
    private func destination(for route: ReportsRoute) -> some View {
        switch route {
        case .sessionDetail(let metrics, let suggestions):
            SessionView(metrics: metrics, suggesions: suggestions)
        case .sessionHistory(let count, let avg, let sessions):
            SessionHistory(sessionCount: count, sessionAvgScore: avg, sessions: sessions)
        case .questionBreakdown(let questions):
            QuestionBreakdownView(questions: questions)
        }
    }
}

#Preview {
    ReportsView()
}
