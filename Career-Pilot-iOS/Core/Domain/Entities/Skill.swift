//
//  Skill.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 21/07/2026.
//

import Foundation

struct Skill : Equatable {
    let skillName: String
    let category: String
    let performanceScore: Int
    let timesAssessed: Int
    let lastAssessedAt: String
}

extension Skill {
    func toDTO() -> SkillDTO {
        SkillDTO(
            skillName: skillName,
            category: category,
            performanceScore: performanceScore,
            timesAssessed: timesAssessed,
            lastAssessedAt: lastAssessedAt
        )
    }
}
