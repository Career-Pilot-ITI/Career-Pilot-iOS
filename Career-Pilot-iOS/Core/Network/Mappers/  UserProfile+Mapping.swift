//
//    UserProfile+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation

extension UserProfile {
    func toDTO() -> UserProfileDTO {
        UserProfileDTO(
            displayName: self.displayName,
            username: self.username,
            email: self.email,
            avatarUrl: self.avatarUrl?.absoluteString,
            gender: self.gender,
            dateOfBirth: self.dateOfBirth?.iso8601String,
            targetRole: self.targetRole,
            industry: self.industry,
            experienceLevel: self.experienceLevel,
            currentJobTitle: self.currentJobTitle,
            yearsOfExperience: self.yearsOfExperience,
            cvUrl: self.cvUrl?.absoluteString,
            skills: self.skills,
            targetCompanies: self.targetCompanies,
            educationLevel: self.educationLevel,
            timezone: self.timezone,
            termsAccepted: self.termsAccepted,
            subscriptionTier: self.subscriptionTier,
            coinBalance: self.coinBalance,
            onboardingCompleted: self.onboardingCompleted,
            trackName: self.trackName
        )
    }
}

// Date helper
private extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: self)
    }
}
