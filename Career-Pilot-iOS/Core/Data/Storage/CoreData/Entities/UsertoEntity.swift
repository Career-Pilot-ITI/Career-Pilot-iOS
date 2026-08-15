//
//  User+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 22/07/2026.
//

import Foundation
import CoreData

extension User {
    func toEntity(in context: NSManagedObjectContext) -> UserEntity {
        let userEntity = UserEntity(context: context)

        userEntity.id = Int64(id)
        userEntity.phoneNumber = phoneNumber
        userEntity.isNewUser = isNewUser

        let profileEntity = profile.toEntity(in: context)
        profileEntity.user = userEntity
        userEntity.profile = profileEntity

        return userEntity
    }
}

extension UserProfile {

    func toEntity(in context: NSManagedObjectContext) -> UserProfileEntity {
     print("Saving the user track id in the database is equal = \(trackId)")
        let entity = UserProfileEntity(context: context)

        entity.displayName = displayName
        entity.username = username
        entity.email = email
        entity.avatarURL = avatarURL
        entity.gender = gender
        entity.dateOfBirth = dateOfBirth
        entity.targetRole = targetRole
        entity.industry = industry
        entity.experienceLevel = experienceLevel
        entity.currentJobTitle = currentJobTitle
        entity.yearsOfExperience = Int64(yearsOfExperience)
        entity.cvURL = cvURL
        entity.educationLevel = educationLevel
        entity.timezone = timezone
        entity.termsAccepted = termsAccepted
        entity.subscriptionTier = subscriptionTier
        entity.coinBalance = Int64(coinBalance)
        entity.onboardingCompleted = onboardingCompleted
        entity.trackId = Int64(trackId)

        // Companies
        let companyEntities = targetCompanies.map { companyName in
            let company = CompanyEntity(context: context)
            company.value = companyName
            company.profile = entity
            return company
        }

        entity.targetCompanies = NSSet(array: companyEntities)

        // Skills
        let skillEntities = skills.map { skill in
            let skillEntity = skill.toEntity(in: context)
            skillEntity.profile = entity
            return skillEntity
        }

        entity.skills = NSSet(array: skillEntities)

        return entity
    }
}

extension Skill {

    func toEntity(in context: NSManagedObjectContext) -> SkillEntity {

        let entity = SkillEntity(context: context)

        entity.skillName = skillName
        entity.category = category
        entity.performanceScore = Int64(performanceScore)
        entity.timesAssessed = Int64(timesAssessed)
        entity.lastAssessedAt = lastAssessedAt

        return entity
    }
}
