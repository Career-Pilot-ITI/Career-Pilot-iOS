//
//  UpdateUserProfileRequest.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 21/07/2026.
//
import Foundation
import CoreData

struct UpdateProfileResponseDTO: Decodable {
    let id: Int
    let phoneNumber: String
    let displayName: String
    let username: String
    let email: String
    let avatarUrl: String?
    let gender: String?
    let dateOfBirth: String?
    let targetRole: String?
    let industry: String?
    let experienceLevel: String?
    let currentJobTitle: String?
    let yearsOfExperience: Int?
    let cvUrl: String?
    let skills: [SkillDTO]
    let targetCompanies: [String]?
    let educationLevel: String?
    let timezone: String?
    let termsAccepted: Bool
    let subscriptionTier: String?
    let coinBalance: Int
    let onboardingCompleted: Bool
    let trackId: Int?
}
extension UserDTO {
    func toEntity(context: NSManagedObjectContext) -> UserEntity {
        let userEntity = UserEntity(context: context)
        userEntity.id = Int64(id)
        userEntity.phoneNumber = phoneNumber
        userEntity.profile = profile.toEntity(context: context)
        return userEntity
    }
}

extension UserProfileDTO {
    func toEntity(context: NSManagedObjectContext) -> UserProfileEntity {
        let profileEntity = UserProfileEntity(context: context)
        profileEntity.displayName = displayName
        profileEntity.username = username
        profileEntity.email = email
        profileEntity.gender = gender
        profileEntity.targetRole = targetRole
        profileEntity.industry = industry
        profileEntity.experienceLevel = experienceLevel
        profileEntity.currentJobTitle = currentJobTitle
        profileEntity.yearsOfExperience = Int64(Int32(yearsOfExperience ?? 0))
        profileEntity.educationLevel = educationLevel
        profileEntity.timezone = timezone
        profileEntity.termsAccepted = termsAccepted ?? false
        profileEntity.subscriptionTier = subscriptionTier
        profileEntity.coinBalance = Int64(Int32(Int64(coinBalance ?? 0)))
        profileEntity.onboardingCompleted = onboardingCompleted ?? false
        
        
        if let skills = skills {
            let skillEntities = skills.map { $0.toEntity(context: context) }
            profileEntity.skills = NSSet(array: skillEntities)
        }
        
        return profileEntity
    }
}
extension UserProfileDTO {
    func toSettingsDomain() -> UserSettingsDomain {
        let cv: URL = cvUrl.flatMap { URL(string: $0) } ?? URL(string: "about:blank")!
        let skillList: [Skill] = skills?.map { $0.toDomain() } ?? []
        
        return UserSettingsDomain(
            displayName: displayName ?? "",
            username: username ?? "",
            phoneNumber: "",
            email: email ?? "",
            avatar: nil,
            targetRole: targetRole,
            industry: industry,
            experienceLevel: experienceLevel ?? "",
            currentJobTitle: currentJobTitle ?? "",
            cvUrl: cv,
            skills: skillList,
            subscriptionTier: subscriptionTier,
            coinBalance: coinBalance ?? 0,
            trackName: "",
            trackId: 0
        )
    }
}
extension UpdateProfileResponseDTO {
    
    @discardableResult
    func toEntity(context: NSManagedObjectContext) -> UserEntity {
        // 1. Fetch or create the UserEntity (Assuming unique by 'id')
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", Int64(id))
        
        let userEntity: UserEntity
        if let existingUser = try? context.fetch(fetchRequest).first {
            userEntity = existingUser
        } else {
            userEntity = UserEntity(context: context)
        }
        
        // 2. Map UserEntity attributes
        userEntity.id = Int64(id)
        userEntity.phoneNumber = phoneNumber
        userEntity.isNewUser = false // Update as appropriate for your logic
        
        // 3. Handle the one-to-one relationship with UserProfileEntity
        let profileEntity: UserProfileEntity
        if let existingProfile = userEntity.profile {
            profileEntity = existingProfile
        } else {
            profileEntity = UserProfileEntity(context: context)
            userEntity.profile = profileEntity
        }
        
        // 4. Map UserProfileEntity attributes
        profileEntity.id = Int64(id)
        profileEntity.displayName = displayName
        profileEntity.username = username
        profileEntity.email = email
        profileEntity.avatarURL = avatarUrl
        profileEntity.gender = gender
        profileEntity.dateOfBirth = dateOfBirth
        profileEntity.targetRole = targetRole
        profileEntity.industry = industry
        profileEntity.experienceLevel = experienceLevel
        profileEntity.currentJobTitle = currentJobTitle
        profileEntity.yearsOfExperience = yearsOfExperience != nil ? Int64(yearsOfExperience!) : 0
        profileEntity.cvURL = cvUrl
        profileEntity.educationLevel = educationLevel
        profileEntity.timezone = timezone
        profileEntity.termsAccepted = termsAccepted
        profileEntity.subscriptionTier = subscriptionTier
        profileEntity.coinBalance = Int64(coinBalance)
        profileEntity.onboardingCompleted = onboardingCompleted
        profileEntity.trackId = trackId != nil ? Int64(trackId!) : 0
        
        // 5. Map skills (assuming SkillDTO has a mapping method to SkillEntity)
        // Clear existing skills relationships if updating
        if let existingSkills = profileEntity.skills as? Set<SkillEntity> {
            existingSkills.forEach { context.delete($0) }
        }
        
        let skillEntities = skills.map { skillDTO -> SkillEntity in
            let skillEntity = SkillEntity(context: context)
            skillEntity.skillName = skillDTO.skillName // Adjust property names based on your SkillDTO/SkillEntity
            skillEntity.category = skillDTO.category
            skillEntity.performanceScore = Int64(skillDTO.performanceScore ?? 0)
            skillEntity.timesAssessed = Int64(skillDTO.timesAssessed ?? 0)
            skillEntity.lastAssessedAt = skillDTO.lastAssessedAt
            skillEntity.profile = profileEntity
            return skillEntity
        }
        profileEntity.skills = NSSet(array: skillEntities)
        
        return userEntity
    }
}
