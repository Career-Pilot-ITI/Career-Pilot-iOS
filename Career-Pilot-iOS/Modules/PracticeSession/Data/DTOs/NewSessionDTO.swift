//
//  NewSessionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

struct NewSessionDTO: Codable {
    let sessionId: Int
    let trackName: String
    let targetDurationMinutes: Int
    let maxQuestions: Int
    let startedAt: Date
    let currentQuestion: QuestionDTO
}
