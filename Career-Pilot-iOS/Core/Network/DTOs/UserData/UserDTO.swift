//
//  UserDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct UserDTO : Codable {
    let id: Int
    let phoneNumber: String
    let profile: UserProfileDTO
    let newUser: Bool
}
