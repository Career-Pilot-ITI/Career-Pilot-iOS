//
//  UserDataRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

protocol UserDataRemoteDataSource{
    func uploadCv(cvURL: URL) async throws -> CvUplodingResponseDTO
}

class UserDataRemoteDataSourceImp: UserDataRemoteDataSource{
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    
    func uploadCv(cvURL: URL) async throws -> CvUplodingResponseDTO {
        let uplodingCvEndPoint: UserDataEndPointes = .analyseCv(cvURL: cvURL)
        
        return try await networkService.request(uplodingCvEndPoint)
    }
}
