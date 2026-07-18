//
//  LoadSessionUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

final class LoadSessionUseCase: UseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    /// No meaningful input — pass `()`.
    func execute(_ input: Void) async throws -> VerifyOTPResult? {
        try await repository.loadSession()
    }
}
