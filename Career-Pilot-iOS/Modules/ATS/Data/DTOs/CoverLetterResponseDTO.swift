//
//  CoverLetterResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 13/08/2026.
//

import Foundation

struct CoverLetterResponseDTO: Decodable {
    let message: String?
    let success: Bool?
    let timestamp: String?
    let data: CoverLetterDTO
}

struct CoverLetterDTO: Decodable {
    let content: String?
    let nextSteps: [String]?
}
