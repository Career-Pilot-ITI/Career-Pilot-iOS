//
//  SessionHistory.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct SessionHistory: View {
    let sessionCount: Int
    let sessionAvgScore: Double
    let sessions: [Session]
    
    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Session History")
                    .font(Font.size22Bold)
                    .foregroundStyle(Color.primaryNavy)
                
                Text("\(sessionCount) sessions · Avg score \(Int(sessionAvgScore))")
                    .font(Font.size14Regular)
                    .foregroundStyle(Color.gray600)
                    .padding(.bottom, 16)
                
                ScrollView {
                   VStack(alignment: .leading, spacing: Spacing.s20) {
                       SessionHistoryListView(sessions: sessions)
                   }
               }
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
        }

    }
}
//
//#Preview {
//    SessionHistory(sessionCount: 6, sessionAvgScore: 76,sessions: [
//        Session(title: "Software Engineering", score: 82, noOfQuestions: 8, perioudTime: "18m", date: "Today"),
//        Session(title: "Software Engineering", score: 74, noOfQuestions: 8, perioudTime: "22m", date: "Yesterday"),
//        Session(title: "System Design", score: 68, noOfQuestions: 6, perioudTime: "15m", date: "Mon 8 Jul"),
//        Session(title: "Software Engineering", score: 79, noOfQuestions: 8, perioudTime: "20m", date: "Sat 6 Jul"),
//        Session(title: "Behavioural", score: 85, noOfQuestions: 10, perioudTime: "25m", date: "Thu 4 Jul"),
//        Session(title: "Software Engineering", score: 71, noOfQuestions: 8, perioudTime: "18m", date: "Mon 1 Jul")
//    ])
//}
