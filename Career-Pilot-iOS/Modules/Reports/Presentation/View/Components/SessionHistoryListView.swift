//
//  SessionHistoryListView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//
import SwiftUI

struct SessionHistoryListView: View {
    @EnvironmentObject var coordinator: AppCoordinator<ReportsRoute>
    let sessions: [Session]

    var body: some View {
        VStack(spacing: Spacing.s12) {
            ForEach(sessions) { session in
                SessionHistroyItem(session: session)
                    .onTapGesture {
                        coordinator.push(.sessionDetail(sessionId: session.id))
                    }
            }
        }
    }
}

//#Preview {
//    ZStack {
//        Color.lightBackGround.ignoresSafeArea()
//        ScrollView {
//            SessionHistoryListView(sessions: [
//                Session(id: 1, title: "Software Engineering", score: 82, noOfQuestions: 8, perioudTime: "18m", date: "Today"),
//                Session(id: 2, title: "Software Engineering", score: 74, noOfQuestions: 8, perioudTime: "22m", date: "Yesterday"),
//                Session(id: 3, title: "System Design", score: 68, noOfQuestions: 6, perioudTime: "15m", date: "Mon 8 Jul")
//            ])
//            .padding(.horizontal, 24)
//            .padding(.vertical, 16)
//        }
//    }
//    .environmentObject(AppCoordinator<ReportsRoute>())
//}
