//
//  FeedbackReportDTOMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension FeedbackReportDTO {
    
    func toDomain() -> InterviewFeedback {
        InterviewFeedback(
            overallScore: overallScore ?? 0,
            clarityScore: clarityScore ?? 0,
            confidenceScore: confidenceScore ?? 0,
            pacingScore: pacingScore ?? 0,
            fillerWordsScore: fillerWordsScore ?? 0,
            contentRelevanceScore: contentRelevanceScore ?? 0,
            coachingTips: coachingTips ?? [],
            questions: questions?.compactMap { $0.toDomain() } ?? []
        )
    }
}

private extension FeedbackReportQuestion {
    
    func toDomain() -> InterviewFeedbackQuestion {
        InterviewFeedbackQuestion(
            question: questionText ?? "",
            transcript: userTranscript ?? "",
            durationMs: durationMs ?? 0,
            speechRateWpm: speechRateWpm ?? 0,
            silenceRatio: silenceRatio ?? 0.0,
            score: score?.toDomain() ?? .init(overall: 0, clarity: 0, confidence: 0, pacing: 0, fillerWords: 0, contentRelevance: 0, coachingTip: "")
        )
    }
}

private extension FeedbackReportScore {
    
    func toDomain() -> InterviewQuestionScore {
        InterviewQuestionScore(
            overall: overallScore ?? 0,
            clarity: clarity ?? 0,
            confidence: confidence ?? 0,
            pacing: pacing ?? 0,
            fillerWords: fillerWords ?? 0,
            contentRelevance: contentRelevance ?? 0,
            coachingTip: coachingTip ?? ""
        )
    }
}

