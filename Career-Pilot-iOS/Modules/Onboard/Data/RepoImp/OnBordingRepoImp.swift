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
        let userDTO = user.toDTO()
        
        let updatedUserDTO = try await remoteDataSource.updateUserProfile(updateProfileDTO:userDTO)
        
        return updatedUserDTO.toDomain()
    }
}
