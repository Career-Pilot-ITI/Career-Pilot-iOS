//
//  UploadCvUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

class UploadCvUseCase: UseCase{
    var userDataRepo: UserDataRepo
    
    init(userDataRepo: UserDataRepo){
        self.userDataRepo = userDataRepo
    }
    
    typealias Input = UploadCvRequest
    typealias Output = UploadCvResponse
    
    func execute(_ input: UploadCvRequest) async throws -> UploadCvResponse {
        return try await userDataRepo.uploadUserCV(uploadCVRequest: input)
    }
}
