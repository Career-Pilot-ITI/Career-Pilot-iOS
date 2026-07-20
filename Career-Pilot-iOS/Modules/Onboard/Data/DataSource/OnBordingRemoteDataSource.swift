//
//  OnBordingRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


protocol OnBordingRemoteDataSource{
    func getAllTraks() async throws -> [TrackDTO]
    func updateProfile(profile: UserProfileDTO) async throws
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
    
    func updateProfile(profile: UserProfileDTO) async throws {
        let endPoint = OnBordingEndPointes.updateProfile(profile: profile)
        try await apiService.request(endPoint)
    }
}
