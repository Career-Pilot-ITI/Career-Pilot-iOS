//
//  OnBordingRepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


class OnBordingRepoImp: OnBordingRepo{
    
    var remoteDataSource: OnBordingRemoteDataSource
    var userLocalDataSource: UserLocalDataSource
    init(remote: OnBordingRemoteDataSource , userLocalDataSource : UserLocalDataSource) {
        self.remoteDataSource = remote
        self.userLocalDataSource = userLocalDataSource
    }
    
    func getAllTracks() async throws -> [Track] {
        return try await remoteDataSource.getAllTraks().map{ trackDTO in
            trackDTO.toDomain()
        }
    }
    
    
    func updateProfile(user: User) async throws -> User {
       
        var  updateProfileRequestDTO = user.toUpdateProfileRequestDTO()
        updateProfileRequestDTO.username = try await userLocalDataSource.getUser()?.profile.username
        let updateProfileResponseDTO =
        try await remoteDataSource.updateUserProfile(updateProfileRequestDTO:updateProfileRequestDTO)

        let user = updateProfileResponseDTO.toDomain()
        
        return user
    }
}
