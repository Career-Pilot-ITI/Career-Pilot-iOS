//
//  ScoreCVAgainstJobUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import Foundation

class ScoreCVAgainstJobUseCase : UseCase {
    private let repository: ATSRepositoryProtocol
    
    init(repository: ATSRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ input: Int) async throws -> JobMatchEntity {
        try await repository.scoreCvAgainstJob(for: input)
    }
}
