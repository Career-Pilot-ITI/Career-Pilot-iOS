//
//  SessionFeedBackMappers.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 09/08/2026.
//

import Foundation

extension InterviewFeedback {
    func toSessionFeedback(
        id: Int = 0,
        sessionId: Int = 0,
        generatedAt: Date = Date(),
        createdAt: Date = Date()
    ) -> SessionFeedback {
        SessionFeedback(
            id: id,
            sessionId: sessionId,
            overallScore: Double(overallScore),
            clarityScore: Double(clarityScore),
            confidenceScore: Double(confidenceScore),
            pacingScore: Double(pacingScore),
            fillerWordsScore: Double(fillerWordsScore),
            contentRelevanceScore: Double(contentRelevanceScore),
            coachingTips: coachingTips,
            generatedAt: generatedAt,
            createdAt: createdAt,
            questions: questions.enumerated().map { index, question in
                question.toSessionQuestion(
                    id: index + 1,
                    sessionId: sessionId,
                    questionOrder: index + 1,
                    createdAt: createdAt
                )
            }
        )
    }
}

// MARK: - InterviewFeedbackQuestion -> SessionQuestion

extension InterviewFeedbackQuestion {
    func toSessionQuestion(
        id: Int = 0,
        sessionId: Int = 0,
        questionOrder: Int = 0,
        createdAt: Date = Date(),
        completedAt: Date? = nil
    ) -> SessionQuestion {
        SessionQuestion(
            id: id,
            sessionId: sessionId,
            questionText: question,
            questionOrder: questionOrder,
            userTranscript: transcript,
            durationMs: durationMs,
            speechRateWpm: Double(speechRateWpm),
            avgPauseMs: 0.0, // Defaulted as source doesn't provide this value
            silenceRatio: silenceRatio,
            createdAt: createdAt,
            completedAt: completedAt,
            score: score.toQuestionScore(
                id: id,
                sessionQuestionId: id,
                createdAt: createdAt
            )
        )
    }
}

// MARK: - InterviewQuestionScore -> QuestionScore

extension InterviewQuestionScore {
    func toQuestionScore(
        id: Int = 0,
        sessionQuestionId: Int = 0,
        createdAt: Date = Date()
    ) -> QuestionScore {
        QuestionScore(
            id: id,
            sessionQuestionId: sessionQuestionId,
            contentRelevance: Double(contentRelevance),
            clarity: Double(clarity),
            confidence: Double(confidence),
            pacing: Double(pacing),
            fillerWords: Double(fillerWords),
            overallScore: Double(overall),
            coachingTip: coachingTip,
            createdAt: createdAt
        )
    }
}

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
            transcript: userTranscript,
            durationMs: durationMs,
            speechRateWpm: Int(round(speechRateWpm)),
            silenceRatio: silenceRatio,
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
