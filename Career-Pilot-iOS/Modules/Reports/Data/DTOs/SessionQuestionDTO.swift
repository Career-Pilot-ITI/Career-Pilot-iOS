//
//  SessionQuestionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

struct SessionQuestionDTO: Codable {
    let id: Int
    let sessionId: Int
    let questionText: String
    let questionOrder: Int
    let userTranscript: String?
    let durationMs: Int?
    let speechRateWpm: Double?
    let avgPauseMs: Double?
    let silenceRatio: Double?
    let createdAt: Date
    let completedAt: Date?
    let score: QuestionScoreDTO?
}
