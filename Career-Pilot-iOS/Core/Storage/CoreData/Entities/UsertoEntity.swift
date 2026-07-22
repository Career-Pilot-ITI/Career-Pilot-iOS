//
//  User+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 22/07/2026.
//

import Foundation
import CoreData

extension User {

    @discardableResult
    func toEntity(in context: NSManagedObjectContext) -> UserEntity {

        let entity = UserEntity(context: context)

        entity.id = Int64(id)
        entity.phoneNumber = phoneNumber
        entity.isNewUser = isNewUser

        let profileEntity = profile.toEntity(in: context)

        profileEntity.user = entity
        entity.profile = profileEntity

        return entity
    }
}


extension UserProfile {

    @discardableResult
    func toEntity(in context: NSManagedObjectContext) -> UserProfileEntity {

        let entity = UserProfileEntity(context: context)

        entity.displayName = displayName
        entity.username = username
        entity.email = email
        entity.avatarUrl = avatarUrl?.absoluteString
        entity.cvUrl = cvUrl?.absoluteString
        entity.gender = gender
        entity.dateOfBirth = dateOfBirth
        entity.targetRole = targetRole
        entity.industry = industry
        entity.experienceLevel = experienceLevel
        entity.currentJobTitle = currentJobTitle
        entity.yearsOfExperience = Int32(yearsOfExperience ?? 0)
        entity.educationLevel = educationLevel
        entity.timezone = timezone
        entity.termsAccepted = termsAccepted
        entity.subscriptionTier = subscriptionTier
        entity.coinBalance = Int32(coinBalance ?? 0)
        entity.onboardingCompleted = onboardingCompleted ?? false
        entity.trackName = trackName

        return entity
    }
}
