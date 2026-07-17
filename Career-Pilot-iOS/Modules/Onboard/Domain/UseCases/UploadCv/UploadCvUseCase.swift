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

    typealias Input = UploadCvRequest
    typealias Output = UploadCvResponse
    
    func excute(input: UploadCvRequest) async throws -> UploadCvResponse {
        return UploadCvResponse(message: "Done")
    }
}
