//
//  AuthenticatedNetworkService.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation

/// A decorator around `NetworkService` that:
///
/// 1. Attaches the Bearer access token to every authenticated request.
/// 2. Intercepts 401 responses and attempts a **silent token refresh**
///    using the stored refresh token.
/// 3. Retries the original request exactly once with the new access token.
/// 4. Deduplicates concurrent refresh calls via `TokenRefreshActor` —
///    multiple simultaneous 401s share one in-flight refresh.
/// 5. Falls back to `onForceLogout` only when the refresh call itself
///    fails (i.e. the refresh token is expired/revoked).
final class AuthenticatedNetworkService: NetworkService {

    private let baseService: NetworkService
    private let tokenProvider: TokenProviding
    private let tokenStore: AuthTokenStoring
    /// Unauthenticated base service — used exclusively for the refresh call
    /// so the expired access token is never sent.
    private let refreshService: NetworkService
    private let refreshActor: TokenRefreshActor
    /// Called on the main actor when a refresh fails and the user must re-login.
    private let onForceLogout: @Sendable () async -> Void

    init(
        baseService: NetworkService,
        tokenProvider: TokenProviding,
        tokenStore: AuthTokenStoring,
        refreshService: NetworkService,
        refreshActor: TokenRefreshActor,
        onForceLogout: @Sendable @escaping () async -> Void
    ) {
        self.baseService = baseService
        self.tokenProvider = tokenProvider
        self.tokenStore = tokenStore
        self.refreshService = refreshService
        self.refreshActor = refreshActor
        self.onForceLogout = onForceLogout
    }

    // MARK: - NetworkService

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let authenticated = try await addAuthIfNeeded(to: endpoint)
        do {
            return try await baseService.request(authenticated)
        } catch {
            if isUnauthorized(error) {
                print("⚠️ [AUTH SERVICE] 401 received — attempting silent refresh")
                try await performRefresh()
                // Retry once with new token
                let retried = try await addAuthIfNeeded(to: endpoint)
                print("🔁 [AUTH SERVICE] Retrying request after refresh")
                return try await baseService.request(retried)
            }
            throw error
        }
    }

    func request(_ endpoint: APIEndpoint) async throws {
        let authenticated = try await addAuthIfNeeded(to: endpoint)
        do {
            try await baseService.request(authenticated)
        } catch {
            if isUnauthorized(error) {
                print("⚠️ [AUTH SERVICE] 401 received — attempting silent refresh")
                try await performRefresh()
                let retried = try await addAuthIfNeeded(to: endpoint)
                print("🔁 [AUTH SERVICE] Retrying request after refresh")
                try await baseService.request(retried)
            } else {
                throw error
            }
        }
    }

    // MARK: - Helpers

    /// Returns true when the error indicates the access token was rejected.
    private func isUnauthorized(_ error: Error) -> Bool {
        if case NetworkError.serverError(let code, _) = error, code == 401 || code == 403 {
            return true
        }
        if case NetworkError.tokenExpired = error { return true }
        if case NetworkError.unauthorized = error  { return true }
        return false
    }

    /// Calls the refresh endpoint via `TokenRefreshActor` so concurrent
    /// calls share one in-flight refresh rather than each issuing their own.
    private func performRefresh() async throws {
        do {
            let newTokens = try await refreshActor.refresh {
                // Read the current refresh token
                let refreshToken = try self.tokenStore.loadTokens()?.refreshToken
                guard let refreshToken else {
                    print("❌ [TOKEN REFRESH] No refresh token available — forcing logout")
                    throw NetworkError.unauthorized
                }

                print("🔄 [TOKEN REFRESH] Calling refresh endpoint")
                let response: RefreshTokenResponseDTO = try await self.refreshService.request(
                    AuthEndPoint.refreshToken(refreshToken: refreshToken)
                )
                let tokens = response.authTokens.toDomain()
                print("✅ [TOKEN REFRESH] New tokens received (expires in \(tokens.expiresIn)s)")
                return tokens
            }

            // Persist the new tokens so subsequent requests pick them up
            try tokenStore.save(newTokens)
            print("✅ [TOKEN REFRESH] New tokens persisted")
        } catch {
            print("❌ [TOKEN REFRESH] Refresh failed: \(error.localizedDescription) — forcing logout")
            try? tokenStore.clear()
            await onForceLogout()
            throw NetworkError.tokenExpired
        }
    }

    private func addAuthIfNeeded(to endpoint: APIEndpoint) async throws -> APIEndpoint {
        guard endpoint.requiresAuthentication else { return endpoint }
        let token = try await tokenProvider.getAccessToken()
        return AuthEndpointDecorator(base: endpoint, token: token)
    }
}

// MARK: - Private decorator

private struct AuthEndpointDecorator: APIEndpoint {
    let base: APIEndpoint
    let token: String

    var baseURL: String             { base.baseURL }
    var path: String                { base.path }
    var method: HTTPMethod          { base.method }
    var queryParameters: [URLQueryItem]? { base.queryParameters }
    var body: Data?                 { base.body }
    var requiresAuthentication: Bool { base.requiresAuthentication }

    var headers: [String: String] {
        var merged = base.headers
        merged["Authorization"] = "Bearer \(token)"
        return merged
    }
}
