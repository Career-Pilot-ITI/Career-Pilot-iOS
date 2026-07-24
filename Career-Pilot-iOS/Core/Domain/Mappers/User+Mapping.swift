//
//  User+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 23/07/2026.
//

import Foundation

extension User{
    func toOnBoardingUser() -> OnBoardingUser{
        
        let components = profile.username
            .split(separator: " ")
            .map(String.init)

        let firstName = components.first ?? ""
        let lastName = components.dropFirst().joined(separator: " ")
        
        return OnBoardingUser(email: profile.email, title: profile.trackName, experienceLevel: profile.experienceLevel, skills: profile.skills, firstName: firstName,lastName: lastName)
    }
}

extension User {
    func toDTO() -> UserDTO {
        UserDTO(
            id: id,
            phoneNumber: phoneNumber,
            profile: profile.toDTO(),
            newUser: isNewUser
        )
    }
}

extension UserProfile {
    func toDTO() -> UserProfileDTO {
        UserProfileDTO(
            id: id,
            phoneNumber: phoneNumber,
            displayName: displayName,
            username: username,
            email: email,
            avatarUrl: avatarURL,
            gender: gender,
            dateOfBirth: dateOfBirth,
            targetRole: targetRole,
            industry: industry,
            experienceLevel: experienceLevel,
            currentJobTitle: currentJobTitle,
            yearsOfExperience: yearsOfExperience,
            cvUrl: cvURL,
            skills: skills.map { $0.toDTO() },
            targetCompanies: targetCompanies,
            educationLevel: educationLevel,
            timezone: timezone,
            termsAccepted: termsAccepted,
            subscriptionTier: subscriptionTier,
            coinBalance: coinBalance,
            onboardingCompleted: onboardingCompleted,
            trackName: trackName
        )
    }
}

extension Skill {
    func toDTO() -> SkillDTO {
        SkillDTO(
            skillName: skillName,
            category: category,
            performanceScore: performanceScore,
            timesAssessed: timesAssessed,
            lastAssessedAt: lastAssessedAt
        )
    }
}

private extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: self)
    }
}
