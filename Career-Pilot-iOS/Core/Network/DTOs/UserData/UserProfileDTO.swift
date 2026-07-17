//
//  UserProfileDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct UserProfileDTO: Decodable {
    let displayName: String
    let username: String
    let email: String
    let avatarUrl: String?
    let gender: String?
    let dateOfBirth: String?
    let targetRole: String?
    let industry: String?
    let experienceLevel: String?
    let currentJobTitle: String?
    let yearsOfExperience: Int?
    let cvUrl: String?
    let skills: [String]?
    let targetCompanies: [String]?
    let educationLevel: String?
    let timezone: String?
    let termsAccepted: Bool?
    let subscriptionTier: String?
    let coinBalance: Int?
    let onboardingCompleted: Bool?
    let trackName: String?
}
