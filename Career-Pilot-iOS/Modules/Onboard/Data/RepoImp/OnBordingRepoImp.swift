//
//  OnBordingRepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


class OnBordingRepoImp: OnBordingRepo{
    
    var remoteDataSource: OnBordingRemoteDataSource
    
    init(remote: OnBordingRemoteDataSource) {
        self.remoteDataSource = remote
    }
    
    func getAllTracks() async throws -> [Track] {
        return try await remoteDataSource.getAllTraks().map{ trackDTO in
            trackDTO.toDomain()
        }
    }
    
    
    func updateProfile(user: User) async throws -> User {
       
        let updateProfileRequestDTO = user.toUpdateProfileRequestDTO()
        
        let updateProfileResponseDTO =
        try await remoteDataSource.updateUserProfile(updateProfileRequestDTO:updateProfileRequestDTO)

        let user = updateProfileResponseDTO.toDomain()
        
        return user
    }
}
