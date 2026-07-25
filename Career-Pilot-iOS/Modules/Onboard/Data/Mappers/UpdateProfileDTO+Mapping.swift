//
//  UpdateProfileDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 21/07/2026.
//

import Foundation

extension UpdateProfileResponseDTO {

    func toDomain(newUser: Bool = false) -> User {
        User(
            id: id,
            phoneNumber: phoneNumber,
            profile: UserProfile(
                id: id,
                phoneNumber: phoneNumber,
                displayName: displayName,
                username: username,
                email: email,
                avatarURL: avatarUrl ?? "",
                gender: gender ?? "",
                dateOfBirth: dateOfBirth ?? "",
                targetRole: targetRole ?? "",
                industry: industry ?? "",
                experienceLevel: experienceLevel ?? "",
                currentJobTitle: currentJobTitle ?? "",
                yearsOfExperience: yearsOfExperience ?? 0,
                cvURL: cvUrl ?? "",
                skills: skills.map { $0.toDomain() },
                targetCompanies: targetCompanies ?? [],
                educationLevel: educationLevel ?? "",
                timezone: timezone ?? "",
                termsAccepted: termsAccepted,
                subscriptionTier: subscriptionTier ?? "",
                coinBalance: coinBalance,
                onboardingCompleted: onboardingCompleted,
                trackName: trackName ?? ""
            ),
            isNewUser: newUser
        )
    }
}
