//
//  UserDataRepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

class UserDataRepoImp: UserDataRepo{
    
    private let remoteDataSource: UserDataRemoteDataSource
    
    init(remoteDataSource: UserDataRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func uploadUserCV(uploadCVRequest: UploadCvRequest) async throws -> UploadCvResponse {
        let cvURL = uploadCVRequest.cv
        let responseResult = try await remoteDataSource.uploadCv(cvURL: cvURL)
        return responseResult.mapToEntity()
    }
    
    
}
