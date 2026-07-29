//
//  RefreshTokenResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created by Antigravity on 29/07/2026.
//

import Foundation

/// Response envelope for the refresh-token endpoint.
/// Shape mirrors the verifyOTP response's `authTokens` field —
/// the server returns a new token pair directly at the top level.
struct RefreshTokenResponseDTO: Decodable {
    let authTokens: AuthTokensDTO
}
