//
//  RepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation

class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    
    init(remoteDataSource: AuthRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func sendOTP(for phoneNumber: String) async throws {
        try await remoteDataSource.sendOTP(for: phoneNumber)
    }
    
    func verifyOTP(for phoneNumber: String, with code: String) async throws -> VerifyOTPResult {
        let dto = try await remoteDataSource.verifyOTP(for: phoneNumber, with: code)
        return dto.toDomain()
    }
}
