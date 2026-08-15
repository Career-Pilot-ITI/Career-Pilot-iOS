//
//  GenerateCoverLetterUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 13/08/2026.
//

import Foundation

class GenerateCoverLetterUseCase: UseCase {
    private let repository: ATSRepositoryProtocol

    init(repository: ATSRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ input: Int) async throws -> CoverLetterEntity {
        try await repository.generateCoverLetter(for: input)
    }
}
