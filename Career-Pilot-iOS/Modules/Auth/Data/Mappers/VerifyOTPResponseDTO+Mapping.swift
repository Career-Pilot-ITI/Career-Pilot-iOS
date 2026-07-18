//
//  VerifyOTPResponseDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

extension VerifyOTPResponseDTO {
    func toDomain() -> VerifyOTPResult {
        VerifyOTPResult(
            authTokens: authTokens.toDomain(),
            user: user.toDomain()
        )
    }
}
