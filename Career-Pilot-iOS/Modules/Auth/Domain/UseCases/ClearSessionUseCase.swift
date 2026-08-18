//
//  ClearSessionUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

final class ClearSessionUseCase: UseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ input: Void) async throws -> Void {
        try await repository.clearSession()
    }
}

