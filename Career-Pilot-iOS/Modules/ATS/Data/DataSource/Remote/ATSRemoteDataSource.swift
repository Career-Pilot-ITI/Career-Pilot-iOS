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
    func optimizeCV(workspaceId: Int) async throws -> CvOptimizeResponseDTO
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

    func optimizeCV(workspaceId: Int) async throws -> CvOptimizeResponseDTO {
        return try await networkService.request(
            CvOptimizeEndPoint.optimize(workspaceId: workspaceId)
        )
    }
}
