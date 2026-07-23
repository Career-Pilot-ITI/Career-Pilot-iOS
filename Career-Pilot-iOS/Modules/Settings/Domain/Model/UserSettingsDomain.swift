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
    let email: String
    let avatarUrl: URL?
    let avatarFileId: Int?
    let cvFileId: Int?
    let targetRole: String?
    let industry: String?
    let experienceLevel: String?
    let currentJobTitle: String?
    let cvUrl: URL?
    let skills: [String]?
    let subscriptionTier: String?
    let coinBalance: Int?
    let trackName: String?
    let trackId: Int?
}
