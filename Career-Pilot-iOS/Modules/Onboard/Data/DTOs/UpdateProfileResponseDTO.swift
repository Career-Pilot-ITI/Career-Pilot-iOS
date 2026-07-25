//
//  UpdateUserProfileRequest.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 21/07/2026.
//
import Foundation

struct UpdateProfileResponseDTO: Decodable {
    let id: Int
    let phoneNumber: String
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
    let skills: [SkillDTO]
    let targetCompanies: [String]?
    let educationLevel: String?
    let timezone: String?
    let termsAccepted: Bool
    let subscriptionTier: String?
    let coinBalance: Int
    let onboardingCompleted: Bool
    let trackName: String?
}
