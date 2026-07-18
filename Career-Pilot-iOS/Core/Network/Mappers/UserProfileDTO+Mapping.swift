//
//  UserProfileDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

extension UserProfileDTO {
    func toDomain() -> UserProfile {
        UserProfile(
            displayName: displayName ?? "",
            username: username ?? "",
            email: email ?? "",
            avatarUrl: avatarUrl.flatMap(URL.init(string:)),
            gender: gender,
            dateOfBirth: dateOfBirth.flatMap(DateFormatter.apiDateOnly.date(from:)),
            targetRole: targetRole,
            industry: industry,
            experienceLevel: experienceLevel,
            currentJobTitle: currentJobTitle,
            yearsOfExperience: yearsOfExperience,
            cvUrl: cvUrl.flatMap(URL.init(string:)),
            skills: skills ?? [],
            targetCompanies: targetCompanies ?? [],
            educationLevel: educationLevel,
            timezone: timezone,
            termsAccepted: termsAccepted ?? false,
            subscriptionTier: subscriptionTier,
            coinBalance: coinBalance ?? 0,
            onboardingCompleted: onboardingCompleted ?? false,
            trackName: trackName
        )
    }
}

extension DateFormatter {
    /// Matches "2026-07-17" style dates from the API.
    static let apiDateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
