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
}

private struct StoredAuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

final class KeychainAuthTokenStore: AuthTokenStoring {
    private let keychain: KeychainManaging
    private let key = "auth.tokens"

    init(keychain: KeychainManaging = KeychainManager()) {
        self.keychain = keychain
    }

    func save(_ tokens: AuthTokens) throws {
        let expiresAt = Date().addingTimeInterval(TimeInterval(tokens.expiresIn))
        let stored = StoredAuthTokens(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
            expiresAt: expiresAt
        )
        try keychain.save(stored, forKey: key)
        
        print("------------------------------------------")
        print("🔑 [SUCCESSFULLY SAVED TOKEN]: \(stored)")
        print("------------------------------------------")
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
}
