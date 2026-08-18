//
//  UserSettingsDomain.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
struct UserSettingsDomain{
    let displayName: String
    let username: String
    let phoneNumber : String
    let email: String
    var avatar: Data?
    var avatarURL : URL?
    let targetRole: String?
    let industry: String?
    let experienceLevel: String
    let currentJobTitle: String
    let cvUrl: URL?
    let skills: [Skill]
    let subscriptionTier: String?
    let coinBalance: Int
    let trackName: String
    let trackId: Int
}
extension UserSettingsDomain {
    /// Maps `UserSettingsDomain` to a `User` entity.
    ///
    /// Properties missing in `UserSettingsDomain` are provided as parameters with default fallback values.
    func toUser(
        id: Int = 0,
        isNewUser: Bool = false,
        gender: String = "",
        dateOfBirth: String = "",
        yearsOfExperience: Int = 0,
        targetCompanies: [String] = [],
        educationLevel: String = "",
        timezone: String = TimeZone.current.identifier,
        termsAccepted: Bool = true,
        onboardingCompleted: Bool = true
    ) -> User {
        let profile = UserProfile(
            displayName: self.displayName,
            username: self.username,
            email: self.email,
            avatarURL: self.avatarURL?.absoluteString ?? "",
            gender: gender,
            dateOfBirth: dateOfBirth,
            targetRole: self.targetRole ?? "",
            industry: self.industry ?? "",
            experienceLevel: self.experienceLevel,
            currentJobTitle: self.currentJobTitle,
            yearsOfExperience: yearsOfExperience,
            cvURL: self.cvUrl?.absoluteString ?? "",
            skills: self.skills,
            targetCompanies: targetCompanies,
            educationLevel: educationLevel,
            timezone: timezone,
            termsAccepted: termsAccepted,
            subscriptionTier: self.subscriptionTier ?? "free",
            coinBalance: self.coinBalance,
            onboardingCompleted: onboardingCompleted,
            trackId: self.trackId
        )
        
        return User(
            id: id,
            phoneNumber: self.phoneNumber,
            profile: profile,
            isNewUser: isNewUser
        )
    }
}
