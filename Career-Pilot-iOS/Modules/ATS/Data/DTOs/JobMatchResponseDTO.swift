//
//  JobMatchResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import Foundation
  
struct JobMatchResponseDTO: Decodable {
    let message: String?
    let success: Bool?
    let timestamp: String?
    let data : JobMatchDTO
}

struct JobMatchDTO: Decodable {
    let overallScore: Int?
    let matchPercentage: Int?
    let matchedSkills: [String]?
    let missingRequiredSkills: [String]?
    let missingPreferredSkills: [String]?
    let strengths: [String]?
    let weaknesses: [String]?
    let sections: [SectionScoreDTO]?
    let recommendations: [String]?
    let coinCost: Int?
    let cvScoreUpdatedAt: String?
}
 
struct SectionScoreDTO: Decodable {
    let section: String?
    let score: Int?
    let feedback: String?
}
