//
//  SkillDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 21/07/2026.
//

import Foundation

struct SkillDTO: Codable {
    let skillName: String?
    let category: String?
    let performanceScore: Int?
    let timesAssessed: Int?
    let lastAssessedAt: String?
}


extension SkillDTO {
    func toDomain() -> Skill {
        Skill(
            skillName: self.skillName ?? "",
            category: self.category ?? "",
            performanceScore: self.performanceScore ?? 0,
            timesAssessed: self.timesAssessed ?? 0,
            lastAssessedAt: self.lastAssessedAt ?? ""
        )
    }
}
