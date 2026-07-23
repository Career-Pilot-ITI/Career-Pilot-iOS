//
//  QuestionBreakdownScreen.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct QuestionBreakdownView: View {
    let questions: [QuestionReview]
    @State private var selectedIndex: Int = 0

    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.s16) {
                    Text("Question Breakdown")
                        .font(Font.size22Bold)
                        .foregroundStyle(Color.primaryNavy)

                    QuestionTabSelector(questions: questions, selectedIndex: $selectedIndex)

                    if let question = questions[safe: selectedIndex] {
                        QuestionPromptCard(questionNumber: question.questionNumber, questionText: question.questionText)
                        QuestionStatsRow(question: question)
                        CoachFeedbackCard(feedback: question.coachFeedback)
                        TranscriptSnippetCard(transcript: question.transcript, flaggedWords: question.flaggedWords)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(false)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

//#Preview {
//    NavigationStack {
//        QuestionBreakdownView(questions: [
//            QuestionReview(
//                questionNumber: 1,
//                questionText: "Tell me about yourself and your background.",
//                score: 88,
//                fillerWordsCount: 3,
//                duration: "1:42",
//                coachFeedback: "Great structure. Consider leading with impact earlier.",
//                transcript: "So, uh, I think the main challenge was… um… basically we had to figure out how the architecture would, you know, handle the load…",
//                flaggedWords: ["uh", "um", "you know", "basically"]
//            ),
//            QuestionReview(
//                questionNumber: 2,
//                questionText: "Describe a time you disagreed with a teammate.",
//                score: 74,
//                fillerWordsCount: 6,
//                duration: "2:05",
//                coachFeedback: "Good conflict resolution example, but rushed the ending.",
//                transcript: "Well, um, there was this one time where, like, we disagreed on the API design…",
//                flaggedWords: ["um", "like"]
//            ),
//            QuestionReview(
//                questionNumber: 3,
//                questionText: "Walk me through a system you designed.",
//                score: 91,
//                fillerWordsCount: 1,
//                duration: "3:10",
//                coachFeedback: "Excellent depth and clear tradeoff reasoning.",
//                transcript: "I designed a caching layer to reduce database load during peak traffic…",
//                flaggedWords: []
//            )
//        ])
//    }
//}
