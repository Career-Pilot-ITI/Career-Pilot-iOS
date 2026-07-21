//
//   UserProfile+Mapping.swift
//   Career-Pilot-iOS
//
//   Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation

extension UserProfile {
    func toUpdateDTO(currentPassword: String? = nil, newPassword: String? = nil, avatarFileId: Int? = nil, cvFileId: Int? = nil) -> UpdateProfileDTO {
        UpdateProfileDTO(
            username: self.username,
            email: self.email,
            currentPassword: currentPassword,
            newPassword: newPassword,
            displayName: self.displayName,
            avatarFileId: avatarFileId,
            gender: self.gender,
            dateOfBirth: self.dateOfBirth?.iso8601String,
            targetRole: self.targetRole,
            industry: self.industry,
            experienceLevel: self.experienceLevel,
            currentJobTitle: self.currentJobTitle,
            yearsOfExperience: self.yearsOfExperience,
            cvFileId: cvFileId,
            skills: self.skills,
            targetCompanies: self.targetCompanies,
            educationLevel: self.educationLevel,
            timezone: self.timezone,
            termsAccepted: self.termsAccepted,
            onboardingCompleted: self.onboardingCompleted,
            subscriptionTier: self.subscriptionTier,
            trackId: self.trackId
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
