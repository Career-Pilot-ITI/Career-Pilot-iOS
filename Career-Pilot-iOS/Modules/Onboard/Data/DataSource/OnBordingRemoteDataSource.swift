//
//  OnBordingRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


protocol OnBordingRemoteDataSource{
    func getAllTraks() async throws -> [TrackDTO]
}

class OnBordingRemoteDataSourceImp: OnBordingRemoteDataSource{
    
    var apiService: NetworkService
    
    init(apiService: NetworkService) {
        self.apiService = apiService
    }
    
    func getAllTraks()  async throws -> [TrackDTO] {
        let endPoint = OnBordingEndPointes.getAllTrackes
        
        return try await apiService.request(endPoint)
    }
}
