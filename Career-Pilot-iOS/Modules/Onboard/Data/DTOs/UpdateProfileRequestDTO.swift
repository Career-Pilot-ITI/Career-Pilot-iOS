//
//  UpdateProfileRequestDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 21/07/2026.
//

import Foundation

struct UpdateProfileRequestDTO: Encodable {
    var username: String?
    let email: String
    let displayName: String
    let avatarUrl: String
    let avatarFileId: Int?
    let gender: String?
    let dateOfBirth: String?
    let targetRole: String
    let industry: String?
    let experienceLevel: String
    let currentJobTitle: String?
    let yearsOfExperience: Int?
    let cvUrl: String?
    let cvFileId: Int?
    let skills: [String]
    let targetCompanies: [String]?
    let educationLevel: String?
    let timezone: String?
    let termsAccepted: Bool?
    let onboardingCompleted: Bool?
    let trackId: Int?
}
