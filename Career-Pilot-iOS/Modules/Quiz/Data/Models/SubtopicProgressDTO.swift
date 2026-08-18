//
//  SubtopicProgressDTO.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation
import FirebaseFirestore

struct SubtopicProgressDTO: Codable {
    @DocumentID var id: String?
    let completed: Bool
    let score: Int
    let totalQuestions: Int
}
