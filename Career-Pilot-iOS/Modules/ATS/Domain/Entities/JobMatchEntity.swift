//
//  JobMatchEntity.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import Foundation

struct JobMatchEntity {
    let overallScore: Int
    let matchPercentage: Int
    let matchedSkills: [String]
    let missingRequiredSkills: [String]
    let missingPreferredSkills: [String]
    let strengths: [String]
    let weaknesses: [String]
    let sections: [SectionScoreEntity]
    let recommendations: [String]
    let coinCost: Int
    let cvScoreUpdatedAt: String

    var totalKeywordsCount: Int {
        matchedSkills.count + missingRequiredSkills.count + missingPreferredSkills.count
    }

    var matchLabel: String {
        switch overallScore {
        case 85...100: return "Excellent Match"
        case 70..<85: return "Good Match"
        case 50..<70: return "Fair Match"
        default: return "Weak Match"
        }
    }
}

struct SectionScoreEntity {
    let section: String
    let score: Int
    let feedback: String
}
