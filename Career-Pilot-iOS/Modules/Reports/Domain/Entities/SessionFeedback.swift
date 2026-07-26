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

