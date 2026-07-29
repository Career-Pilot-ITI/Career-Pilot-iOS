//
//  TokenProvider.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation

protocol TokenProviding {
    func getAccessToken() async throws -> String
    func getRefreshToken() async throws -> String
}

/// Reads the current access token from the keychain.
///
/// This provider only throws if there are **no tokens at all** (`.unauthorized`).
/// Near-expiry detection is intentionally removed here — expiry is handled
/// reactively by `AuthenticatedNetworkService` when the server returns a 401,
/// and the actual refresh is coordinated by `TokenRefreshActor`.
final class AuthTokenProvider: TokenProviding {
    private let tokenStore: AuthTokenStoring

    init(tokenStore: AuthTokenStoring) {
        self.tokenStore = tokenStore
    }

    func getAccessToken() async throws -> String {
        guard let tokens = try tokenStore.loadTokens() else {
            print("🔑 [TOKEN PROVIDER] No tokens found — user must log in")
            throw NetworkError.unauthorized
        }

        print("------------------------------------------")
        print("🔑 [TOKEN PROVIDER] Access token loaded (expires in \(tokens.expiresIn)s)")
        print("------------------------------------------")

        return tokens.accessToken
    }

    func getRefreshToken() async throws -> String {
        guard let tokens = try tokenStore.loadTokens() else {
            print("🔑 [TOKEN PROVIDER] No refresh token found — user must log in")
            throw NetworkError.unauthorized
        }
        return tokens.refreshToken
    }
}
