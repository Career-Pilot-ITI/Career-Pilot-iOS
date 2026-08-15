//
//  TriggerCvOptimizeUseCase.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation

class TriggerCvOptimizeUseCase: UseCase {
    private let repository: ATSRepositoryProtocol
    
    init(repository: ATSRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ input: Int) async throws -> CvOptimizeResponse {
        try await repository.optimizeCV(workspaceId: input)
    }
}
