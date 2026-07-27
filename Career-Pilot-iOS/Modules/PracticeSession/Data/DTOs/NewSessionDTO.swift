//
//  NewSessionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

struct NewSessionDTO: Decodable {
    let sessionId: Int?
    let trackName: String?
    let targetDurationMinutes: Int?
    let maxQuestions: Int?
    let startedAt: String?
    let currentQuestion: QuestionDTO?
}

struct QuestionDTO: Decodable {
    let id: Int?
    let sessionId: Int?
    let questionText: String?
    let questionOrder: Int?
    let createdAt: String?
}
