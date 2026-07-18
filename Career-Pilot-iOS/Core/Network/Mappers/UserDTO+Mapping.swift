//
//  UserDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

extension UserDTO {
    func toDomain() -> User {
        User(
            id: id,
            phoneNumber: phoneNumber,
            profile: profile.toDomain(),
            isNewUser: newUser
        )
    }
}
