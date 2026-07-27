//
//  UserDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation
import CoreData

struct UserDTO: Decodable {
    let id: Int
    let phoneNumber: String
    let profile: UserProfileDTO
    let newUser: Bool
}

struct UserProfileDTO: Decodable {
    let displayName: String?
    let username: String?
    let email: String?
    let avatarUrl: String?
    let gender: String?
    let dateOfBirth: String?
    let targetRole: String?
    let industry: String?
    let experienceLevel: String?
    let currentJobTitle: String?
    let yearsOfExperience: Int?
    let cvUrl: String?
    let skills: [SkillDTO]?
    let targetCompanies: [String]?
    let educationLevel: String?
    let timezone: String?
    let termsAccepted: Bool?
    let subscriptionTier: String?
    let coinBalance: Int?
    let onboardingCompleted: Bool?
    let trackId: Int?
}

struct SkillDTO: Decodable {
    let skillName: String?
    let category: String?
    let performanceScore: Int?
    let timesAssessed: Int?
    let lastAssessedAt: String?
}
extension SkillDTO {
    @discardableResult
    func toEntity(context: NSManagedObjectContext) -> SkillEntity {
        let entity = SkillEntity(context: context)
        entity.skillName = skillName
        entity.category = category
        entity.performanceScore = Int64(performanceScore ?? 0)
        entity.timesAssessed = Int64(timesAssessed ?? 0)
        entity.lastAssessedAt = lastAssessedAt
        return entity
    }
}
