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
