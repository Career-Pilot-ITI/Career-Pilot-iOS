//
//  AuthTokens.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct AuthTokens: Equatable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
}
