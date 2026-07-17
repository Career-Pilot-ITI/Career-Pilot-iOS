//
//  UserDataRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

protocol UserDataRemoteDataSource{
    func uploadCv(cvURL: URL) async throws -> CvUplodingApiResponse
}

class UserDataRemoteDataSourceImp: UserDataRemoteDataSource{
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }
    
    
    func uploadCv(cvURL: URL) async throws -> CvUplodingApiResponse {
        let cvAsData = try Data(contentsOf: cvURL) //HAVE to map the error
        
        let uplodingCvEndPoint: UserDataEndPointes = .uploadFile(file: cvAsData, fileType: .CVs)
        
        return try await networkService.request(uplodingCvEndPoint)
    }
}
