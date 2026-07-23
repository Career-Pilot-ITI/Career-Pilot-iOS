//
//  QuestionTabSelector.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct QuestionReview: Identifiable, Hashable {
    let id = UUID()
    let questionNumber: Int
    let questionText: String
    let score: Int
    let fillerWordsCount: Int
    let duration: String
    let coachFeedback: String
    let transcript: String
    let flaggedWords: [String]
}

struct QuestionTabSelector: View {
    let questions: [QuestionReview]
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: Spacing.s8) {
            ForEach(Array(questions.enumerated()), id: \.element.id) { index, question in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                } label: {
                    Text("Q\(question.questionNumber)")
                        .font(Font.size14Bold)
                        .foregroundStyle(selectedIndex == index ? .white : Color.primaryNavy)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(selectedIndex == index ? Color.primaryNavy : Color.white)
                        }
                }
            }
            Spacer()
        }
    }
}
//
//#Preview {
//    QuestionTabSelector(questions: [
//        QuestionReview(
//            questionNumber: 1,
//            questionText: "Tell me about yourself and your background.",
//            score: 88,
//            fillerWordsCount: 3,
//            duration: "1:42",
//            coachFeedback: "Great structure. Consider leading with impact earlier.",
//            transcript: "So, uh, I think the main challenge was… um… basically we had to figure out how the architecture would, you know, handle the load…",
//            flaggedWords: ["uh", "um", "you know", "basically"]
//        ),
//        QuestionReview(
//            questionNumber: 2,
//            questionText: "Describe a time you disagreed with a teammate.",
//            score: 74,
//            fillerWordsCount: 6,
//            duration: "2:05",
//            coachFeedback: "Good conflict resolution example, but rushed the ending.",
//            transcript: "Well, um, there was this one time where, like, we disagreed on the API design…",
//            flaggedWords: ["um", "like"]
//        ),
//        QuestionReview(
//            questionNumber: 3,
//            questionText: "Walk me through a system you designed.",
//            score: 91,
//            fillerWordsCount: 1,
//            duration: "3:10",
//            coachFeedback: "Excellent depth and clear tradeoff reasoning.",
//            transcript: "I designed a caching layer to reduce database load during peak traffic…",
//            flaggedWords: []
//        )
//    ], selectedIndex: .constant(1))
//}
