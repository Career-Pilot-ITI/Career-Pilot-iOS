//
//  ATSRepository.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

class ATSRepository : ATSRepositoryProtocol {
    private let localDataSource: ATSRemoteDataSourceProtocol
    
    init(localDataSource: ATSRemoteDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
    func getJobByURL(from url: String) async throws -> JobEntity {
        let dto = try await localDataSource.getJobByURL(from: url)
        let result = dto.data?.toDomain()
        return result
    }
}
