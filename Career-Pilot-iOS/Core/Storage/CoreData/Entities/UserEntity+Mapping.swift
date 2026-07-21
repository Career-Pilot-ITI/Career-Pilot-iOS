//
//  UserEntity+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

enum LocalStoreError: Error {
    case missingProfile
}

extension UserEntity {
    func toDomain() throws -> User {
        guard let profileEntity = profile else {
            throw LocalStoreError.missingProfile
        }
        return User(
            id: Int(id),
            phoneNumber: phoneNumber ?? "",
            profile: profileEntity.toDomain(),
            isNewUser: isNewUser
        )
    }
}

extension UserProfileEntity {
    func toDomain() -> UserProfile {
        let avatar: URL? = avatarUrl.flatMap { URL(string: $0) }
        let cv: URL? = cvUrl.flatMap { URL(string: $0) }
        let years: Int? = yearsOfExperience == 0 ? nil : Int(yearsOfExperience)

        let skillsSet: Set<SkillEntity> = (skills as? Set<SkillEntity>) ?? []
        let skillList: [String] = skillsSet.map { $0.value ?? "" }

        let companiesSet: Set<TargetCompanyEntity> = (targetCompanies as? Set<TargetCompanyEntity>) ?? []
        let companyList: [String] = companiesSet.map { $0.value ?? "" }

        return UserProfile(
                displayName: displayName ?? "",
                username: username ?? "",
                email: email ?? "",
                avatarUrl: avatar,
                avatarFileId: 0,
                cvFileId: 0,
                gender: gender,
                dateOfBirth: dateOfBirth,
                targetRole: targetRole,
                industry: industry,
                experienceLevel: experienceLevel,
                currentJobTitle: currentJobTitle,
                yearsOfExperience: Int(yearsOfExperience),
                cvUrl: cv,
                skills: skillList,
                targetCompanies: companyList,
                educationLevel: educationLevel,
                timezone: timezone,
                termsAccepted: termsAccepted,
                subscriptionTier: subscriptionTier,
                coinBalance: Int(coinBalance),
                onboardingCompleted: onboardingCompleted,
                trackName: trackName ?? "",
                trackId: 0
            )
    }
}
