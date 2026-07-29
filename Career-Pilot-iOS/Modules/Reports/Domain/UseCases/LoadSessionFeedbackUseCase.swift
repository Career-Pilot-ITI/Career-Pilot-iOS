//
//  LoadSessionFeedbackUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

struct LoadSessionFeedbackInput {
    let sessionId: Int
    let forceRefresh: Bool
}

final class LoadSessionFeedbackUseCase: UseCase {
    private let repository: ReportsRepositoryProtocol

    init(repository: ReportsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ input: LoadSessionFeedbackInput) async throws -> SessionFeedback {
        try await repository.loadFeedback(sessionId: input.sessionId, forceRefresh: input.forceRefresh)
    }
}
