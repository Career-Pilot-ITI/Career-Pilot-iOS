//
//  PollCvOptimizeJobUseCase.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation

struct PollJobInput: Hashable {
    let workspaceId: Int
    let jobId: Int
}

class PollCvOptimizeJobUseCase: UseCase {
    private let repository: ATSRepositoryProtocol
    
    init(repository: ATSRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ input: PollJobInput) async throws -> AiJobEntity {
        try await repository.pollCvOptimizeJobStatus(
            workspaceId: input.workspaceId,
            jobId: input.jobId
        )
    }
}
