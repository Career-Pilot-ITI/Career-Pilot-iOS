//
//  QuestionBreakDownView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct QuestionBreakDownView: View {
    @EnvironmentObject var coordinator : AppCoordinator<ReportsRoute>
    var body: some View {
        Button {
            coordinator.push(.questionBreakdown(questions: [
                QuestionReview(
                    questionNumber: 1,
                    questionText: "Tell me about yourself and your background.",
                    score: 88,
                    fillerWordsCount: 3,
                    duration: "1:42",
                    coachFeedback: "Great structure. Consider leading with impact earlier.",
                    transcript: "So, uh, I think the main challenge was… um… basically we had to figure out how the architecture would, you know, handle the load…",
                    flaggedWords: ["uh", "um", "you know", "basically"]
                ),
                QuestionReview(
                    questionNumber: 2,
                    questionText: "Describe a time you disagreed with a teammate.",
                    score: 74,
                    fillerWordsCount: 6,
                    duration: "2:05",
                    coachFeedback: "Good conflict resolution example, but rushed the ending.",
                    transcript: "Well, um, there was this one time where, like, we disagreed on the API design…",
                    flaggedWords: ["um", "like"]
                ),
                QuestionReview(
                    questionNumber: 3,
                    questionText: "Walk me through a system you designed.",
                    score: 91,
                    fillerWordsCount: 1,
                    duration: "3:10",
                    coachFeedback: "Excellent depth and clear tradeoff reasoning.",
                    transcript: "I designed a caching layer to reduce database load during peak traffic…",
                    flaggedWords: []
                )
            ]))
        } label: {
            HStack() {
                Image(systemName: "doc.text")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.activeColour)
                    .padding(.trailing,12)
                    
                Text("View per-question breakdown")
                    .font(Font.size16SemiBold)
                    .foregroundStyle(Color.primaryNavy)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.gray400)
                
            }.padding(.all,16)
                .background {
                    RoundedRectangle(cornerRadius: Radius.r16)
                        .fill(.white)
                }
        } 
    }
}

//#Preview {
//    ZStack() {
//        Color.lightBackGround
//        VStack {
//            Spacer()
//            QuestionBreakDownView()
//            Spacer()
//        }
//        .padding(.horizontal, 24)
//    }
//}
