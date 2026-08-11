//
//  GetJobByURL.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

class GetJobByURLUseCase : UseCase {
    private let repository: ATSRepositoryProtocol
    
    init(repository: ATSRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ input: String) async throws -> JobEntity {
        
        try await repository.getJobByURL(from: input)
    }
}

