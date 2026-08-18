//
//  RemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Moaz Osama on 17/07/2026.
//

import Foundation

protocol AuthRemoteDataSourceProtocol {
    func sendOTP(for phoneNumber: String) async throws
    func verifyOTP(for phoneNumber: String, with code: String) async throws -> VerifyOTPResponseDTO
}

class AuthRemoteDataSource : AuthRemoteDataSourceProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = URLSessionNetworkService()) {
        self.networkService = networkService
    }
    
    func sendOTP(for phoneNumber: String) async throws {
        try await networkService.request(AuthEndPoint.sendOTP(phoneNumber: phoneNumber))
    }
    
    func verifyOTP(for phoneNumber: String, with code: String) async throws -> VerifyOTPResponseDTO {
        try await networkService.request(AuthEndPoint.verifyOTP(phoneNumber: phoneNumber, code: code))
    }
}
