//
//  UserProfile.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct UserProfile: Equatable {
    
    let displayName: String
    let username: String
    let email: String
    let avatarUrl: URL
    let avatarFileId: Int
    let cvFileId: Int
    let gender: String
    let dateOfBirth: Date
    let targetRole: String
    let industry: String
    let experienceLevel: String
    let currentJobTitle: String
    let yearsOfExperience: Int
    let cvUrl: URL
    let skills: [Skill]
    let targetCompanies: [String]
    let educationLevel: String
    let timezone: String
    let termsAccepted: Bool
    let subscriptionTier: String
    let coinBalance: Int
    let onboardingCompleted: Bool
    let trackName: String
    let trackId: Int
}
