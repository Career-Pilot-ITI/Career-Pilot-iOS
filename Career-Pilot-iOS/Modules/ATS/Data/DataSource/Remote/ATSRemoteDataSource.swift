//
//  ATSRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

protocol ATSRemoteDataSourceProtocol {
    func getJobByURL(from url: String) async throws -> JobDetailsResponseDTO
    func scoreCvAgainstJob(for id: Int) async throws -> JobMatchResponseDTO
    func generateCoverLetter(for id: Int) async throws -> CoverLetterResponseDTO
    func triggerCvOptimize(workspaceId: Int) async throws -> AiJobResponseDTO
    func pollCvOptimizeJobStatus(workspaceId: Int, jobId: Int) async throws -> AiJobResponseDTO
}

class ATSRemoteDataSource : ATSRemoteDataSourceProtocol {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getJobByURL(from url: String) async throws -> JobDetailsResponseDTO {
        let cleanedPath = url.replacingOccurrences(of: "\\", with: "")
        print("the url requested is \(cleanedPath)")
        return try await networkService.request(ATSEndPoint.getJobUrl(url: cleanedPath))
    }
    
    func scoreCvAgainstJob(for id: Int) async throws -> JobMatchResponseDTO {
        return try await networkService.request(ATSEndPoint.scoreCVAgainstJob(id: id))
    }

    func generateCoverLetter(for id: Int) async throws -> CoverLetterResponseDTO {
        return try await networkService.request(ATSEndPoint.generateCoverLetter(id: id))
    }

    func triggerCvOptimize(workspaceId: Int) async throws -> AiJobResponseDTO {
        return try await networkService.request(
            CvOptimizeEndPoint.triggerOptimize(workspaceId: workspaceId)
        )
    }

    func pollCvOptimizeJobStatus(workspaceId: Int, jobId: Int) async throws -> AiJobResponseDTO {
        return try await networkService.request(
            CvOptimizeEndPoint.pollJobStatus(workspaceId: workspaceId, jobId: jobId)
        )
    }
}
