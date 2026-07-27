//
//  SkillDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 21/07/2026.
//

import Foundation
import CoreData

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
extension SkillDTO {
    func toEntity(context: NSManagedObjectContext) -> SkillEntity {
        let skillEntity = SkillEntity(context: context)
        skillEntity.skillName = skillName
        skillEntity.category = category
        skillEntity.performanceScore = Int32(performanceScore ?? 0)
        skillEntity.timesAssessed = Int32(timesAssessed ?? 0)
        skillEntity.lastAssessedAt = lastAssessedAt
        return skillEntity
    }
}

