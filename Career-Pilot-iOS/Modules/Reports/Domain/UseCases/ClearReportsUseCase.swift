//
//  ClearReportsUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

final class ClearReportsUseCase: UseCase {
    typealias Input = Int   // userId
    typealias Output = Void

    private let repository: ReportsRepositoryProtocol

    init(repository: ReportsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ input: Int) async throws {
        try await repository.deleteAllSessions(for: input)
    }
}
