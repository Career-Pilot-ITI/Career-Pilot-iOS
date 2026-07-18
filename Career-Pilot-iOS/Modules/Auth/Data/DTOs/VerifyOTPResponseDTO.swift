//
//  VerifyOTPResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct VerifyOTPResponseDTO: Decodable {
    let authTokens: AuthTokensDTO
    let user: UserDTO
}
