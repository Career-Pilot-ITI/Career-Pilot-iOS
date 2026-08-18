//
//  QuizQuestionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation
import FirebaseFirestore

struct QuizQuestionDTO: Codable {
    @DocumentID var id: String?
    let questionText: String
    let options: [String]
    let correctIndex: Int
}
