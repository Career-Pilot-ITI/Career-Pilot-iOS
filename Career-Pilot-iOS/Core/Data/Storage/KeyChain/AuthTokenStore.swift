//
//  AuthTokenStore.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

protocol AuthTokenStoring {
    func save(_ tokens: AuthTokens) throws
    func loadTokens() throws -> AuthTokens?
    func clear() throws
    func refreshTokensIfNeeded() async throws -> Bool
}

private struct StoredAuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

final class KeychainAuthTokenStore: AuthTokenStoring {
    private let keychain: KeychainManaging
    private let refreshService: NetworkService?
    private let refreshActor: TokenRefreshActor?
    private let key = "auth.tokens"

    init(
        keychain: KeychainManaging = KeychainManager(),
        refreshService: NetworkService? = nil,
        refreshActor: TokenRefreshActor? = nil
    ) {
        self.keychain = keychain
        self.refreshService = refreshService
        self.refreshActor = refreshActor
    }

    func save(_ tokens: AuthTokens) throws {
        let expiresAt = Date().addingTimeInterval(TimeInterval(tokens.expiresIn))
        let stored = StoredAuthTokens(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
            expiresAt: expiresAt
        )
        try keychain.save(stored, forKey: key)
        
        print("✅ [TOKEN STORE] Tokens saved successfully")
    }

    func loadTokens() throws -> AuthTokens? {
        guard let stored = try keychain.get(StoredAuthTokens.self, forKey: key) else {
            return nil
        }
        let remainingSeconds = max(0, Int(stored.expiresAt.timeIntervalSinceNow))
        return AuthTokens(
            accessToken: stored.accessToken,
            refreshToken: stored.refreshToken,
            expiresIn: remainingSeconds
        )
    }

    func clear() throws {
        try keychain.delete(forKey: key)
    }

    func refreshTokensIfNeeded() async throws -> Bool {
        guard let refreshService, let refreshActor else {
            return false
        }

        guard let tokens = try loadTokens() else {
            return false
        }

        let buffer: TimeInterval = 60
        let expiresAt = Date().addingTimeInterval(TimeInterval(tokens.expiresIn))
        guard expiresAt <= Date().addingTimeInterval(buffer) else {
            return true
        }

        guard !tokens.refreshToken.isEmpty else {
            return false
        }

        let newTokens = try await refreshActor.refresh {
            let response: RefreshTokenResponseDTO = try await refreshService.request(
                AuthEndPoint.refreshToken(refreshToken: tokens.refreshToken)
            )
            return response.authTokens.toDomain()
        }

        try save(newTokens)
        return true
    }
}
