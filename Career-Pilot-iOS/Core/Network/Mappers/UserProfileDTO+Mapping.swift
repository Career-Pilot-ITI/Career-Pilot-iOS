//
//  UserProfileDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

extension UserProfileDTO {
    func toDomain() -> UserData {
        let nameParts = displayName.split(separator: " ", maxSplits: 1)

        return UserData(
            email: email,
            title: currentJobTitle ?? "",
            experienceLevel: experienceLevel ?? "",
            skills: skills ?? [],
            firstName: nameParts.first.map(String.init) ?? "",
            lastName: nameParts.count > 1 ? String(nameParts[1]) : ""
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
