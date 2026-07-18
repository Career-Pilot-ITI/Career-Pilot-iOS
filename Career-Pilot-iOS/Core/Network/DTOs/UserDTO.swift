//
//  UserDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct UserDTO : Decodable {
    let id: Int	
    let phoneNumber: String
    let profile: UserProfileDTO
    let newUser: Bool
}

	
