//
//  UserModelSettingsView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation
import UIKit
import Foundation
import UIKit

struct UserModelSettingsView: Equatable {
    var email: String
    var title: String
    var fullName: String
    var avatar: UIImage?
    var experienceLevel: String
    var skills: [Skill]
    var coinBalance: String
    var subscriptionPlan: String
    var phoneNumber: String
    var cvUrl: URL?
    var username: String
    var avatarURL: URL?
    var targetRole: String?
    var industry: String?
    var trackName: String
    var trackId: Int
}
