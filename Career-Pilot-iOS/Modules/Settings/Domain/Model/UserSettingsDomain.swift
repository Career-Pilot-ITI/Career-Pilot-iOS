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
