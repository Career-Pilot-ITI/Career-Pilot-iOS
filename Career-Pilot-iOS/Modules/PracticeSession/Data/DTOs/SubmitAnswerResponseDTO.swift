//
//  SubmitAnswerResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

struct SubmitAnswerResponseDTO: Codable {
    let sessionStatus: String
    let score: ScoreDTO
    let nextQuestion: QuestionDTO?
}

struct ScoreDTO: Codable {
    let id: Int
    let sessionQuestionId: Int
    let contentRelevance: Int
    let clarity: Int
    let confidence: Int
    let pacing: Int
    let fillerWords: Int
    let overallScore: Int
    let coachingTip: String
    let createdAt: String
}

