//
//  SubtopicEntity.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation

struct SubtopicEntity: Identifiable {
    let id: String
    let title: String
    let order: Int
    var isCompleted: Bool
    var score: Int?
    var totalQuestions: Int?
}

struct QuestionEntity: Identifiable {
    let id: String
    let questionText: String
    let options: [String]
    let correctIndex: Int
}
