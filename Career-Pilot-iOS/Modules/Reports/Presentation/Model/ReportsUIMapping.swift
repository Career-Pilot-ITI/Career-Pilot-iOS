//
//  ReportsUIMapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import SwiftUI

extension ReportsInterviewSessionDTO {
    func toUIModel() -> Session {
        Session(
            id: id,   // real session id
            title: trackName,
            score: overallScore,
            noOfQuestions: maxQuestions,
            perioudTime: "\(durationSeconds / 60)m",
            date: createdAt.formattedRelative()
        )
    }
}

extension SessionFeedbackDTO {
    func toRadarMetrics() -> [RadarMetric] {
        [
            RadarMetric(label: "Clarity", value: clarityScore, color: colorFor(clarityScore)),
            RadarMetric(label: "Confidence", value: confidenceScore, color: colorFor(confidenceScore)),
            RadarMetric(label: "Pacing", value: pacingScore, color: colorFor(pacingScore)),
            RadarMetric(label: "Filler Words", value: fillerWordsScore, color: colorFor(fillerWordsScore)),
            RadarMetric(label: "Content", value: contentRelevanceScore, color: colorFor(contentRelevanceScore))
        ]
    }

    func toCoachingSuggestions() -> [CoachingSuggestion] {
        coachingTips.enumerated().map { index, tip in
            CoachingSuggestion(
                icon: "target",
                text: tip,
                description: tip,
                badgeLevel: index == 0 ? "High impact" : (index == 1 ? "Medium impact" : "Low impact")
            )
        }
    }

    func toQuestionReviews() -> [QuestionReview] {
        questions.map { $0.toQuestionReview() }
    }

    private func colorFor(_ value: Double) -> Color {
        value >= 80 ? .green : .orange
    }
}

extension SessionQuestionDTO {
    func toQuestionReview() -> QuestionReview {
        QuestionReview(
            questionNumber: questionOrder,
            questionText: questionText,
            score: Int(score?.overallScore ?? 0),
            fillerWordsCount: Int(score?.fillerWords ?? 0),
            duration: "\(durationMs / 1000 / 60):\(String(format: "%02d", (durationMs / 1000) % 60))",
            coachFeedback: score?.coachingTip ?? "",
            transcript: userTranscript,
            flaggedWords: []
        )
    }
}
