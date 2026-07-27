//
//  FeedbackReportDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

struct FeedbackReportDTO: Decodable {
    let id: Int?
    let sessionId: Int?
    let overallScore: Int?
    let clarityScore: Int?
    let confidenceScore: Int?
    let pacingScore: Int?
    let fillerWordsScore: Int?
    let contentRelevanceScore: Int?
    let coachingTips: [String]?
    let generatedAt: String?
    let createdAt: String?
    let questions: [FeedbackReportQuestion]?
}

struct FeedbackReportQuestion: Decodable {
    let id: Int?
    let sessionId: Int?
    let questionText: String?
    let questionOrder: Int?
    let userTranscript: String?
    let durationMs: Int?
    let speechRateWpm: Int?
    let avgPauseMs: Int?
    let silenceRatio: Double?
    let createdAt: String?
    let completedAt: String?
    let score: FeedbackReportScore?
}

struct FeedbackReportScore: Decodable {
    let id: Int?
    let sessionQuestionId: Int?
    let contentRelevance: Int?
    let clarity: Int?
    let confidence: Int?
    let pacing: Int?
    let fillerWords: Int?
    let overallScore: Int?
    let coachingTip: String?
    let createdAt: String?
}
