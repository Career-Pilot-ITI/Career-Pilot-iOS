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
            phoneNumber: phoneNumber,
            profile: profileEntity.toDomain(),
            isNewUser: isNewUser
        )
    }
}

extension UserProfileEntity {
    func toDomain() -> UserProfile {
        UserProfile(
            displayName: displayName ?? "",
            username: username,
            email: email ?? "",
            avatarUrl: avatarUrl.flatMap(URL.init(string:)),
            gender: gender,
            dateOfBirth: dateOfBirth,
            targetRole: targetRole,
            industry: industry,
            experienceLevel: experienceLevel,
            currentJobTitle: currentJobTitle,
            yearsOfExperience: yearsOfExperience == 0 ? nil : Int(yearsOfExperience),
            cvUrl: cvUrl.flatMap(URL.init(string:)),
            skills: (skills as? Set<SkillEntity>)?.map(\.value) ?? [],
            targetCompanies: (targetCompanies as? Set<TargetCompanyEntity>)?.map(\.value) ?? [],
            educationLevel: educationLevel,
            timezone: timezone,
            termsAccepted: termsAccepted,
            subscriptionTier: subscriptionTier,
            coinBalance: Int(coinBalance),
            onboardingCompleted: onboardingCompleted,
            trackName: trackName
        )
    }
}

