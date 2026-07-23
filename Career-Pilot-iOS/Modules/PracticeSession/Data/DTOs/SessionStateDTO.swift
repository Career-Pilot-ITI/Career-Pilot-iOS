//
//  SessionStateDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 22/07/2026.
//

import Foundation

struct SessionStateDTO: Decodable {
    let sessionId: Int
    let status: String
    let trackName: String
    let startedAt: Date
    let updatedAt: Date
    let answeredCount: Int
    let totalCount: Int
    let answeredQuestions: [AnsweredQuestionDTO]
    let currentQuestion: QuestionDTO?
}

// MARK: - Answered Question
struct AnsweredQuestionDTO: Decodable {
    let id: Int
    let sessionId: Int
    let questionText: String
    let questionOrder: Int
    let userTranscript: String
    let durationMs: Int
    let speechRateWpm: Double
    let avgPauseMs: Double
    let silenceRatio: Double
    let createdAt: String
    let completedAt: String
    let score: ScoreDTO?
}
