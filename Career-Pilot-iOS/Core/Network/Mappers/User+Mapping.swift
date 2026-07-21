//
//  User+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 21/07/2026.
//

import Foundation

extension User {
    func toDTO() -> UpdateProfileDTO {
        return UpdateProfileDTO(
            username: self.profile.username,
            email: self.profile.email,
            currentPassword: nil,
            newPassword: nil,
            displayName: self.profile.displayName,
            avatarFileId: self.profile.avatarFileId,
            gender: self.profile.gender,
            dateOfBirth: self.profile.dateOfBirth?.iso8601String,
            targetRole: self.profile.targetRole,
            industry: self.profile.industry,
            experienceLevel: self.profile.experienceLevel,
            currentJobTitle: self.profile.currentJobTitle,
            yearsOfExperience: self.profile.yearsOfExperience,
            cvFileId: self.profile.cvFileId,
            skills: self.profile.skills,
            targetCompanies: self.profile.targetCompanies,
            educationLevel: self.profile.educationLevel,
            timezone: self.profile.timezone,
            termsAccepted: self.profile.termsAccepted,
            onboardingCompleted: self.profile.onboardingCompleted,
            subscriptionTier: self.profile.subscriptionTier,
            trackId: self.profile.trackId
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
