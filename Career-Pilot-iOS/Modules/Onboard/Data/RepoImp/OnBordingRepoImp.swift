//
//  OnBordingRepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


class OnBordingRepoImp: OnBordingRepo{
    
    var remote: OnBordingRemoteDataSource
    
    init(remote: OnBordingRemoteDataSource) {
        self.remote = remote
    }
    
    func getAllTracks() async throws -> [Track] {
        return try await remote.getAllTraks().map{ trackDTO in
            trackDTO.toDomain()
        }
    }
    
    func updateProfile(profile: UserProfile) async throws {
        let dto = profile.toDTO()
        try await remote.updateProfile(profile: dto)
    }
}
