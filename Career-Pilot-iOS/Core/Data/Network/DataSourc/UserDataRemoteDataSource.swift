//
//  UserDataRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//
//

import Foundation

protocol UserDataRemoteDataSource {
    func uploadCv(cvURL: URL) async throws -> CvUplodingResponseDTO
    func uploadFile(fileURL: URL, fileType: FileTypes) async throws -> UploadFileResponseDTO
}

class UserDataRemoteDataSourceImp: UserDataRemoteDataSource {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func uploadCv(cvURL: URL) async throws -> CvUplodingResponseDTO {
        let boundary = "Boundary-\(UUID().uuidString)"
        let uplodingCvEndPoint: UserDataEndpoints = .analyseCV(cvURL, boundary: boundary)
        print("UploadCvEndpoint: \(uplodingCvEndPoint)")
        return try await networkService.request(uplodingCvEndPoint)
    }

    func uploadFile(fileURL: URL, fileType: FileTypes) async throws -> UploadFileResponseDTO {
        let boundary = "Boundary-\(UUID().uuidString)"
        let uplodingFileEndPoint: UserDataEndpoints = .uploadFile(fileURL, fileType, boundary: boundary)

        print("uploadFileEndpoint: \(uplodingFileEndPoint)")
        return try await networkService.request(uplodingFileEndPoint)
    }
}
