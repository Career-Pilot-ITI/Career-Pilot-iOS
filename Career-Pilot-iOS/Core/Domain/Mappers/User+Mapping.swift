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
        
        return OnBoardingUser(email: profile.email, title: profile.targetRole, experienceLevel: profile.experienceLevel, skills: profile.skills, firstName: firstName,lastName: lastName)
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
            trackId: trackId
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


extension User {
    func toUpdateProfileRequestDTO(
        avatarFileId: Int? = nil,
        cvFileId: Int? = nil
    ) -> UpdateProfileRequestDTO {
        UpdateProfileRequestDTO(
            username: profile.username,
            email: profile.email,
            displayName: profile.displayName,
            avatarUrl: profile.avatarURL,
            avatarFileId: avatarFileId,
            gender: profile.gender,
            dateOfBirth: profile.dateOfBirth,
            targetRole: profile.targetRole,
            industry: profile.industry,
            experienceLevel: profile.experienceLevel,
            currentJobTitle: profile.currentJobTitle,
            yearsOfExperience: profile.yearsOfExperience,
            cvUrl: profile.cvURL,
            cvFileId: cvFileId,
            skills: profile.skills.map(\.skillName),
            targetCompanies: profile.targetCompanies,
            educationLevel: profile.educationLevel,
            timezone: profile.timezone,
            termsAccepted: profile.termsAccepted,
            onboardingCompleted: profile.onboardingCompleted,
            trackId: profile.trackId
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


// MARK: - User Guest Default
extension User {
    /// Standard Guest user representation
    static let guest = User(
        id: -1,
        phoneNumber: "",
        profile: .guest,
        isNewUser: false
    )
}

// MARK: - UserProfile Guest Default
extension UserProfile {
    static let guest = UserProfile(
        displayName: "Guest User",
        username: "guest",
        email: "",
        avatarURL: "",
        gender: "",
        dateOfBirth: "",
        targetRole: "Explore",
        industry: "General",
        experienceLevel: "Entry",
        currentJobTitle: "",
        yearsOfExperience: 0,
        cvURL: "",
        skills: [],
        targetCompanies: [],
        educationLevel: "",
        timezone: TimeZone.current.identifier,
        termsAccepted: false,
        subscriptionTier: "Free",
        coinBalance: 0,
        onboardingCompleted: false,
        trackId: 0
    )
}

// MARK: - Skill Default / Mock Extensions
extension Skill {
    static let sample = Skill(
        skillName: "General Knowledge",
        category: "Overview",
        performanceScore: 0,
        timesAssessed: 0,
        lastAssessedAt: ""
    )
}
