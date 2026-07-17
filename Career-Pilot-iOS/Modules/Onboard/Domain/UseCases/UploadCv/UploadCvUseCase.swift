//
//  UploadCvUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

protocol UseCase{
    associatedtype Input
    associatedtype Output
    
    func excute(input: Input) async throws -> Output
}

class UploadCvUseCase: UseCase{

    var userDataRepo: UserDataRepo
    
    init(userDataRepo: UserDataRepo){
        self.userDataRepo = userDataRepo
    }
    
    typealias Input = UploadCvRequest
    typealias Output = UploadCvResponse
    
    func excute(input: UploadCvRequest) async throws -> UploadCvResponse {
        return try await userDataRepo.uploadUserCV(uploadCVRequest: input)
    }
}
