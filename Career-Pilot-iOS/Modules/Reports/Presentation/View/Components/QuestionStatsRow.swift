//
//  QuestionStatsRow.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct QuestionStatsRow: View {
    let question: QuestionReview

    var body: some View {
        HStack(spacing: Spacing.s12) {
            StatCard(value: "\(question.score)", label: "Score", valueColor: Color.successColour)
            StatCard(value: "\(question.fillerWordsCount)", label: "Filler words", valueColor: Color.primaryYellow)
            StatCard(value: question.duration, label: "Duration", valueColor: Color.primary)
        }
    }
}
//
//#Preview {
//    QuestionStatsRow(question: QuestionReview(
//        questionNumber: 1,
//        questionText: "Tell me about yourself and your background.",
//        score: 88,
//        fillerWordsCount: 3,
//        duration: "1:42",
//        coachFeedback: "Great structure. Consider leading with impact earlier.",
//        transcript: "So, uh, I think the main challenge was… um… basically we had to figure out how the architecture would, you know, handle the load…",
//        flaggedWords: ["uh", "um", "you know", "basically"]
//    ))
//}
