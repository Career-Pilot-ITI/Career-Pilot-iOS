//
//  SessionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

struct SessionDTO: Codable {
    let sessionId: Int
    let trackName: String
    let targetDurationMinutes: Int
    let maxQuestions: Int
    let startedAt: Date
    let currentQuestion: Question
}

struct Question: Codable {
    let id: Int
    let sessionId: Int
    let questionText: String
    let questionOrder: Int
    let createdAt: Date
}
