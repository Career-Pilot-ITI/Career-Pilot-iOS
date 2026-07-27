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
        profileEntity.avatarUrl = avatarUrl
        profileEntity.gender = gender
        profileEntity.targetRole = targetRole
        profileEntity.industry = industry
        profileEntity.experienceLevel = experienceLevel
        profileEntity.currentJobTitle = currentJobTitle
        profileEntity.yearsOfExperience = Int32(yearsOfExperience ?? 0)
        profileEntity.cvUrl = cvUrl
        profileEntity.educationLevel = educationLevel
        profileEntity.timezone = timezone
        profileEntity.termsAccepted = termsAccepted ?? false
        profileEntity.subscriptionTier = subscriptionTier
        profileEntity.coinBalance = Int32(Int64(coinBalance ?? 0))
        profileEntity.onboardingCompleted = onboardingCompleted ?? false
        profileEntity.trackName = trackName
        
        
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
            trackName: trackName ?? "",
            trackId: 0
        )
    }
}
