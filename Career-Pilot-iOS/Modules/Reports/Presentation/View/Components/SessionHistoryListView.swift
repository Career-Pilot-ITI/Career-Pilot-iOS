//
//  SessionHistoryListView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//
import SwiftUI

struct SessionHistoryListView: View {
    let sessions: [Session]

    var body: some View {
        VStack(spacing: Spacing.s12) {
            ForEach(sessions) { session in
                SessionHistroyItem(session: session)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.lightBackGround.ignoresSafeArea()

        ScrollView {
            SessionHistoryListView(sessions: [
                Session(title: "Software Engineering", score: 82, noOfQuestions: 8, perioudTime: "18m", date: "Today"),
                Session(title: "Software Engineering", score: 74, noOfQuestions: 8, perioudTime: "22m", date: "Yesterday"),
                Session(title: "System Design", score: 68, noOfQuestions: 6, perioudTime: "15m", date: "Mon 8 Jul"),
                Session(title: "Software Engineering", score: 79, noOfQuestions: 8, perioudTime: "20m", date: "Sat 6 Jul"),
                Session(title: "Behavioural", score: 85, noOfQuestions: 10, perioudTime: "25m", date: "Thu 4 Jul"),
                Session(title: "Software Engineering", score: 71, noOfQuestions: 8, perioudTime: "18m", date: "Mon 1 Jul")
            ])
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }
}
