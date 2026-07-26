//
//  QuestionScoreDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

struct QuestionScoreDTO: Codable {
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
