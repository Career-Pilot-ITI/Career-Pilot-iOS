//
//  UserEntity+Mapping.swift
//  Career-Pilot-iOS
//

import Foundation

enum LocalStoreError: Error {
    case missingProfile
}

extension UserEntity {

    func toDomain() throws -> User {
        guard let profile = profile else {
            throw LocalStoreError.missingProfile
        }

        return User(
            id: Int(id),
            phoneNumber: phoneNumber ?? "",
            profile: profile.toDomain(),
            isNewUser: isNewUser
        )
    }
}

extension UserProfileEntity {

    func toDomain() -> UserProfile {

        let skillEntities = (skills as? Set<SkillEntity>) ?? []
        let companyEntities = (targetCompanies as? Set<CompanyEntity>) ?? []

        return UserProfile(
            displayName: displayName ?? "",
            username: username ?? "",
            email: email ?? "",
            avatarURL: avatarURL ?? "",
            gender: gender ?? "",
            dateOfBirth: dateOfBirth ?? "",
            targetRole: targetRole ?? "",
            industry: industry ?? "",
            experienceLevel: experienceLevel ?? "",
            currentJobTitle: currentJobTitle ?? "",
            yearsOfExperience: Int(yearsOfExperience),
            cvURL: cvURL ?? "",
            skills: skillEntities.map { $0.toDomain() },
            targetCompanies: companyEntities.compactMap(\.value),
            educationLevel: educationLevel ?? "",
            timezone: timezone ?? "",
            termsAccepted: termsAccepted,
            subscriptionTier: subscriptionTier ?? "",
            coinBalance: Int(coinBalance),
            onboardingCompleted: onboardingCompleted,
            trackId: Int(trackId)
        )
    }
}

extension SkillEntity {

    func toDomain() -> Skill {
        Skill(
            skillName: skillName ?? "",
            category: category ?? "",
            performanceScore: Int(performanceScore),
            timesAssessed: Int(timesAssessed),
            lastAssessedAt: lastAssessedAt ?? ""
        )
    }
}
