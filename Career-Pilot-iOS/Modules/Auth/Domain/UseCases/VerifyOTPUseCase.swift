//
//  VerifyOTPUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

class VerifyOTPUseCase : UseCase {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ input: VerifyOTPInput) async throws -> VerifyOTPResult {
        try await repository.verifyOTP(for: input.phoneNumber, with: input.code)
    }
}

struct VerifyOTPInput {
    let phoneNumber: String
    let code: String
}


