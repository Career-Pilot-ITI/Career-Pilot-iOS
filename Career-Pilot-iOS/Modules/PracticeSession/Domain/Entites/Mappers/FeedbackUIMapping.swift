//
//  FeedbackUIMapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 09/08/2026.
//

import Foundation
import SwiftUI

extension InterviewFeedback {
    func toRadarMetrics() -> [RadarMetric] {
        [
            RadarMetric(label: "Clarity",      value: Double(clarityScore),          color: colorFor(clarityScore)),
            RadarMetric(label: "Confidence",   value: Double(confidenceScore),       color: colorFor(confidenceScore)),
            RadarMetric(label: "Pacing",       value: Double(pacingScore),           color: colorFor(pacingScore)),
            RadarMetric(label: "Filler Words", value: Double(fillerWordsScore),      color: colorFor(fillerWordsScore)),
            RadarMetric(label: "Content",      value: Double(contentRelevanceScore), color: colorFor(contentRelevanceScore))
        ]
    }

    func toCoachingSuggestions() -> [CoachingSuggestion] {
        coachingTips.enumerated().map { index, tip in
            CoachingSuggestion(
                icon: "target",
                text: tip,
                description: tip,
                badgeLevel: index == 0 ? "High impact" : (index == 1 ? "Medium" : "Low")
            )
        }
    }

    func toQuestionReviews() -> [QuestionReview] {
        questions.enumerated().map { index, question in
            question.toQuestionReview(questionNumber: index + 1)
        }
    }

    private func colorFor(_ value: Int) -> Color {
        value >= 80 ? .green : .orange
    }
}

extension InterviewFeedbackQuestion {
    func toQuestionReview(questionNumber: Int = 1) -> QuestionReview {
        QuestionReview(
            questionNumber: questionNumber,
            questionText: question,
            score: score.overall,
            fillerWordsCount: score.fillerWords,
            duration: "\(durationMs / 1000 / 60):\(String(format: "%02d", (durationMs / 1000) % 60))",
            coachFeedback: score.coachingTip,
            transcript: transcript,
            flaggedWords: []
        )
    }
}
