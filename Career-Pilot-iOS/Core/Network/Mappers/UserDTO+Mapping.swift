//
//  UserDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

extension UserDTO {
    func toDomain() -> User {
        User(
            id: id,
            phoneNumber: phoneNumber,
            profile: profile.toDomain(),
            isNewUser: newUser
        )
    }
}

extension UserProfileDTO {
    func toDomain() -> UserProfile {
        UserProfile(
            id: id,
            phoneNumber: phoneNumber,
            displayName: displayName ?? "",
            username: username ?? "",
            email: email ?? "",
            avatarURL: avatarUrl ?? "",
            gender: gender ?? "",
            dateOfBirth: dateOfBirth ?? "",
            targetRole: targetRole ?? "",
            industry: industry ?? "",
            experienceLevel: experienceLevel ?? "",
            currentJobTitle: currentJobTitle ?? "",
            yearsOfExperience: yearsOfExperience ?? 0,
            cvURL: cvUrl ?? "",
            skills: (skills ?? []).map { $0.toDomain() },
            targetCompanies: targetCompanies ?? [],
            educationLevel: educationLevel ?? "",
            timezone: timezone ?? "",
            termsAccepted: termsAccepted ?? false,
            subscriptionTier: subscriptionTier ?? "",
            coinBalance: coinBalance ?? 0,
            onboardingCompleted: onboardingCompleted ?? false,
            trackId: trackId ?? 0
        )
    }
}

extension SkillDTO {
    func toDomain() -> Skill {
        Skill(
            skillName: skillName ?? "",
            category: category ?? "",
            performanceScore: performanceScore ?? 0,
            timesAssessed: timesAssessed ?? 0,
            lastAssessedAt: lastAssessedAt ?? ""
        )
    }
}
