//
//  File.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation
import FirebaseFirestore

struct SubtopicDTO: Codable {
    @DocumentID var id: String?
    let title: String
    let order: Int
}

