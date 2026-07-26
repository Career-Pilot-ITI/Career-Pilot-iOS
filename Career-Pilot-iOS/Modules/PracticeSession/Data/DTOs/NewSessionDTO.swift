//
//  NewSessionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

struct NewSessionResponseDTO: Codable {
    let message: String
    let success: Bool
    let timestamp: String
    let data: NewSessionDTO
}

struct NewSessionDTO: Codable {
    let sessionId: Int
    let trackName: String
    let targetDurationMinutes: Int
    let maxQuestions: Int
    let startedAt: String
    let currentQuestion: QuestionDTO
}

struct QuestionDTO: Codable {
    let id: Int
    let sessionId: Int
    let questionText: String
    let questionOrder: Int
    let createdAt: String
}

