//
//  SessionFeedBackMappers.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 09/08/2026.
//

import Foundation

extension SessionFeedback {
    func toInterviewFeedback() -> InterviewFeedback {
        InterviewFeedback(
            overallScore: Int(round(overallScore)),
            clarityScore: Int(round(clarityScore)),
            confidenceScore: Int(round(confidenceScore)),
            pacingScore: Int(round(pacingScore)),
            fillerWordsScore: Int(round(fillerWordsScore)),
            contentRelevanceScore: Int(round(contentRelevanceScore)),
            coachingTips: coachingTips,
            questions: questions.map { $0.toInterviewFeedbackQuestion() }
        )
    }
}

// MARK: - SessionQuestion -> InterviewFeedbackQuestion
extension SessionQuestion {
    func toInterviewFeedbackQuestion() -> InterviewFeedbackQuestion {
        InterviewFeedbackQuestion(
            question: questionText,
            transcript: userTranscript ?? "",
            durationMs: durationMs ?? 0,
            speechRateWpm: Int(round(speechRateWpm ?? 0 )) ,
            silenceRatio: silenceRatio ?? 0,
            score: score?.toInterviewQuestionScore() ?? .empty
        )
    }
}

// MARK: - QuestionScore -> InterviewQuestionScore

extension QuestionScore {
    func toInterviewQuestionScore() -> InterviewQuestionScore {
        InterviewQuestionScore(
            overall: Int(round(overallScore)),
            clarity: Int(round(clarity)),
            confidence: Int(round(confidence)),
            pacing: Int(round(pacing)),
            fillerWords: Int(round(fillerWords)),
            contentRelevance: Int(round(contentRelevance)),
            coachingTip: coachingTip
        )
    }
}
