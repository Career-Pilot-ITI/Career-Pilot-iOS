//
//  SessionFeedback.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

struct SessionFeedback: Equatable, Identifiable {
    let id: Int
    let sessionId: Int
    let overallScore: Double
    let clarityScore: Double
    let confidenceScore: Double
    let pacingScore: Double
    let fillerWordsScore: Double
    let contentRelevanceScore: Double
    let coachingTips: [String]
    let generatedAt: Date
    let createdAt: Date
    let questions: [SessionQuestion]
}

struct SessionQuestion: Equatable, Identifiable {
    let id: Int
    let sessionId: Int
    let questionText: String
    let questionOrder: Int
    let userTranscript: String
    let durationMs: Int
    let speechRateWpm: Double
    let avgPauseMs: Double
    let silenceRatio: Double
    let createdAt: Date
    let completedAt: Date?
    /// Optional: a question may not have a score yet (e.g. session still in progress).
    let score: QuestionScore?
}


struct QuestionScore: Equatable, Identifiable {
    let id: Int
    let sessionQuestionId: Int
    let contentRelevance: Double
    let clarity: Double
    let confidence: Double
    let pacing: Double
    let fillerWords: Double
    let overallScore: Double
    let coachingTip: String
    let createdAt: Date
}

