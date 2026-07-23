//
//  UserDataRepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

class UserDataRepoImp: UserDataRepo{
    
    private let remoteDataSource: UserDataRemoteDataSource
    private let localDataSource: UserLocalDataSource

    init(remoteDataSource: UserDataRemoteDataSource,localDataSource: UserLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func saveUser(_ user: User) async throws -> Bool {
           try await localDataSource.saveUser(user)
       }

    func getUser() async throws -> User? {
           try await localDataSource.getUser()
     }

    func uploadUserCV(uploadCVRequest: UploadCvRequest) async throws -> UploadCvResponse {
        let cvURL = uploadCVRequest.cv
        let responseResult = try await remoteDataSource.uploadCv(cvURL: cvURL)
        return responseResult.toDomain()
    }
    
    
}
