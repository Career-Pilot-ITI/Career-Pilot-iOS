//
//  User.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//
import Foundation

struct User: Equatable {
    let id: Int
    let phoneNumber: String
    let profile: UserProfile
    let isNewUser: Bool
}

struct UserProfile: Equatable {
    let id: Int
    let phoneNumber: String
    let displayName: String
    let username: String
    let email: String
    let avatarURL: String
    let gender: String
    let dateOfBirth: String
    let targetRole: String
    let industry: String
    let experienceLevel: String
    let currentJobTitle: String
    let yearsOfExperience: Int
    let cvURL: String
    let skills: [Skill]
    let targetCompanies: [String]
    let educationLevel: String
    let timezone: String
    let termsAccepted: Bool
    let subscriptionTier: String
    let coinBalance: Int
    let onboardingCompleted: Bool
    let trackName: String
}

struct Skill: Equatable {
    let skillName: String
    let category: String
    let performanceScore: Int
    let timesAssessed: Int
    let lastAssessedAt: String
}
