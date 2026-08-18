//
//  AuthTokensDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct AuthTokensDTO : Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}

