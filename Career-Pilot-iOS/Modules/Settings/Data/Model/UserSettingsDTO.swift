//
//  UserSettingsDTO.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 26/07/2026.
//

import Foundation
struct UserSettingsDTO: Decodable {
    let id: Int
    let phoneNumber: String?
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
    let trackName: String?
    let isnewUser:Bool?
}
import Foundation
import CoreData

extension UserSettingsDTO {
    
    /// Converts and saves/updates the DTO into Core Data entities (`UserEntity` and `UserProfileEntity`).
    @discardableResult
    func toEntity(in context: NSManagedObjectContext) -> UserEntity {
        // 1. Fetch existing UserEntity or create a new one to avoid duplicates
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        let existingUser = (try? context.fetch(fetchRequest))?.first
        let userEntity = existingUser ?? UserEntity(context: context)
        
        userEntity.id = Int64(id)
        userEntity.phoneNumber = phoneNumber
        // Note: 'isNewUser' can be set based on your business logic or defaulted
        userEntity.isNewUser = isnewUser ?? false
        // 2. Handle the One-to-One relationship for UserProfileEntity
        let profileEntity = userEntity.profile ?? UserProfileEntity(context: context)
        profileEntity.avatarUrl = avatarUrl
        profileEntity.coinBalance = Int32(coinBalance ?? 0)
        profileEntity.currentJobTitle = currentJobTitle
        profileEntity.cvUrl = cvUrl
        
        // Convert Date string to Date object if needed (adjust format to match your API)
        if let dobString = dateOfBirth {
            let formatter = ISO8601DateFormatter()
            profileEntity.dateOfBirth = formatter.date(from: dobString)
        }
        
        profileEntity.displayName = displayName
        profileEntity.educationLevel = educationLevel
        profileEntity.email = email
        profileEntity.experienceLevel = experienceLevel
        profileEntity.gender = gender
        profileEntity.industry = industry
        profileEntity.onboardingCompleted = onboardingCompleted ?? false
        profileEntity.subscriptionTier = subscriptionTier
        profileEntity.targetRole = targetRole
        profileEntity.termsAccepted = termsAccepted ?? false
        profileEntity.timezone = timezone
        profileEntity.trackName = trackName
        profileEntity.username = username
        profileEntity.yearsOfExperience = Int32(yearsOfExperience ?? 0)
        
        // 3. Clear and Map Skills Relationship
        if let existingSkills = profileEntity.skills as? Set<SkillEntity> {
            existingSkills.forEach { context.delete($0) }
        }
        
        if let skillDTOs = skills {
            for skillDTO in skillDTOs {
                let skillEntity = SkillEntity(context: context)
                skillEntity.skillName = skillDTO.skillName
                skillEntity.category = skillDTO.category
                skillEntity.performanceScore = Int32(skillDTO.performanceScore ?? 0)
                skillEntity.timesAssessed = Int32(skillDTO.timesAssessed ?? 0)
                skillEntity.lastAssessedAt = skillDTO.lastAssessedAt
                skillEntity.profile = profileEntity
            }
        }
        
        // 4. Clear and Map Target Companies Relationship
        if let existingCompanies = profileEntity.targetCompanies as? Set<TargetCompanyEntity> {
            existingCompanies.forEach { context.delete($0) }
        }
        
        if let companyNames = targetCompanies {
            for name in companyNames {
                let companyEntity = TargetCompanyEntity(context: context)
                companyEntity.value = name
                companyEntity.profile = profileEntity
            }
        }
        
        // Link profile back to user
        profileEntity.user = userEntity
        userEntity.profile = profileEntity
        
        return userEntity
    }
}
