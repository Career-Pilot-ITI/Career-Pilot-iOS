//
//  FeedbackReportDTOMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension FeedbackReportDTO {
    
    func toDomain() -> InterviewFeedback {
        InterviewFeedback(
            overallScore: overallScore,
            clarityScore: clarityScore,
            confidenceScore: confidenceScore,
            pacingScore: pacingScore,
            fillerWordsScore: fillerWordsScore,
            contentRelevanceScore: contentRelevanceScore,
            coachingTips: coachingTips,
            questions: questions.map { $0.toDomain() }
        )
    }
}

private extension FeedbackReportQuestion {
    
    func toDomain() -> InterviewFeedbackQuestion {
        InterviewFeedbackQuestion(
            question: questionText,
            transcript: userTranscript,
            durationMs: durationMs,
            speechRateWpm: speechRateWpm,
            silenceRatio: silenceRatio,
            score: score.toDomain()
        )
    }
}

private extension FeedbackReportScore {
    
    func toDomain() -> InterviewQuestionScore {
        InterviewQuestionScore(
            overall: overallScore,
            clarity: clarity,
            confidence: confidence,
            pacing: pacing,
            fillerWords: fillerWords,
            contentRelevance: contentRelevance,
            coachingTip: coachingTip
        )
    }
}
