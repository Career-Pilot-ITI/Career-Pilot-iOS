//
//  RepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation

class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let tokenStore: AuthTokenStoring
    private let userLocalDataSource: UserLocalDataSource
    
    init(
        remoteDataSource: AuthRemoteDataSourceProtocol,
        tokenStore: AuthTokenStoring,
        userLocalDataSource: UserLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.tokenStore = tokenStore
        self.userLocalDataSource = userLocalDataSource
    }
    
    func sendOTP(for phoneNumber: String) async throws {
        try await remoteDataSource.sendOTP(for: phoneNumber)
    }
    
    func verifyOTP(for phoneNumber: String, with code: String) async throws -> VerifyOTPResult {
        let dto = try await remoteDataSource.verifyOTP(for: phoneNumber, with: code)
        let result = dto.toDomain()
        
        try tokenStore.save(result.authTokens)
        try await userLocalDataSource.saveUser(result.user)

        return result
    }

    func loadSession() async throws -> VerifyOTPResult? {
        guard let tokens = try tokenStore.loadTokens() else {
            // Nothing in Keychain — no session
            return nil
        }

        let buffer: TimeInterval = 60
        let expiresAt = Date().addingTimeInterval(TimeInterval(tokens.expiresIn))
        if expiresAt <= Date().addingTimeInterval(buffer) {
            // Access token expired or about to expire — attempt refresh
            let refreshed = try await tokenStore.refreshTokensIfNeeded()
            guard refreshed else {
                try? await clearSession()
                return nil
            }
        }

        guard let refreshedTokens = try tokenStore.loadTokens() else {
            try? await clearSession()
            return nil
        }

        guard let user = try await userLocalDataSource.getUser() else {
            // Tokens are valid but the cached user is missing
            try? await clearSession()
            return nil
        }

        return VerifyOTPResult(authTokens: refreshedTokens, user: user)
    }

    func clearSession() async throws {
        try tokenStore.clear()
        try await userLocalDataSource.deleteUser()
    }
}
