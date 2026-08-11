//
//  ATSRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

protocol ATSRemoteDataSourceProtocol {
    func getJobByURL(from url: String) async throws -> JobMatchResultDTO
}

class ATSRemoteDataSource : ATSRemoteDataSourceProtocol {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getJobByURL(from url: String) async throws -> JobMatchResultDTO {
        let cleanedPath = url.replacingOccurrences(of: "\\", with: "")
        print("the url requested is \(cleanedPath)")
        return try await networkService.request(ATSEndPoint.getJobUrl(url: cleanedPath))
    }
    
}
