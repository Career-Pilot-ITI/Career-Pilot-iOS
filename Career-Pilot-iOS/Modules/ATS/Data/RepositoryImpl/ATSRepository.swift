//
//  ATSRepository.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

class ATSRepository : ATSRepositoryProtocol {
    private let remoteDataSource: ATSRemoteDataSourceProtocol
    
    init(remoteDataSource: ATSRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getJobByURL(from url: String) async throws -> JobEntity {
        let dto = try await remoteDataSource.getJobByURL(from: url)
        let result = dto.data.toEntity()
        return result
    }
    
    func scoreCvAgainstJob(for id: Int) async throws -> JobMatchEntity {
        do {
            let dto = try await remoteDataSource.scoreCvAgainstJob(for: id)
            return dto.data.toEntity()
        } catch {
            throw ATSScoringError(error: error)
        }
    }

    func generateCoverLetter(for id: Int) async throws -> CoverLetterEntity {
        let dto = try await remoteDataSource.generateCoverLetter(for: id)
        return dto.data.toEntity()
    }

    func triggerCvOptimize(workspaceId: Int) async throws -> AiJobEntity {
        let dto = try await remoteDataSource.triggerCvOptimize(workspaceId: workspaceId)
        return dto.data.toEntity()
    }

    func pollCvOptimizeJobStatus(workspaceId: Int, jobId: Int) async throws -> AiJobEntity {
        let dto = try await remoteDataSource.pollCvOptimizeJobStatus(workspaceId: workspaceId, jobId: jobId)
        return dto.data.toEntity()
    }

}
