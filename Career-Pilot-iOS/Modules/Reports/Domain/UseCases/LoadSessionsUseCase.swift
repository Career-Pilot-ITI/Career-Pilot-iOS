//
//  LoadSessionsUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

struct LoadSessionsInput {
    let forceRefresh: Bool
}

final class LoadSessionsUseCase: UseCase {
    private let repository: ReportsRepositoryProtocol
    private let currentUserProvider: CurrentUserProviding

    init(repository: ReportsRepositoryProtocol, currentUserProvider: CurrentUserProviding) {
        self.repository = repository
        self.currentUserProvider = currentUserProvider
    }

    func execute(_ input: LoadSessionsInput) async throws -> [ReportsInterviewSessionDTO] {
        let userId = try await currentUserProvider.currentUserId()
        return try await repository.loadSessions(for: userId, forceRefresh: input.forceRefresh)
    }
}
