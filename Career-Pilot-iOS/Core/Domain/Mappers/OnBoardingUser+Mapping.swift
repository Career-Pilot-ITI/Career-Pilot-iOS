//
//  OnBoardingUser+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

import Foundation

extension OnBoardingUser {

    func toUser(
        id: Int = 0,
        phoneNumber: String = "",
        isNewUser: Bool = true
    ) -> User {

        User(
            id: id,
            phoneNumber: phoneNumber,
            profile: UserProfile(
                displayName: fullName,
                username: "ahmed_elsayyad",
                email: email,
                avatarURL: avatarUrl ?? "",
                gender: gender ?? "male",
                dateOfBirth: "",
                targetRole: title,
                industry: "",
                experienceLevel: experienceLevel,
                currentJobTitle: "",
                yearsOfExperience: 0,
                cvURL: cv?.absoluteString ?? "",
                skills: skills,
                targetCompanies: [],
                educationLevel: "",
                timezone: TimeZone.current.identifier,
                termsAccepted: false,
                subscriptionTier: "",
                coinBalance: 0,
                onboardingCompleted: false,
                trackId: selectedTrack?.id ?? 0
            ),
            isNewUser: isNewUser
        )
    }
}
