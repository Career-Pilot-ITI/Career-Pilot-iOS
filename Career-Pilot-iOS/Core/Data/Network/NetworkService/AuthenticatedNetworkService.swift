//
//  AuthenticatedNetworkService.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation


final class AuthenticatedNetworkService: NetworkService {

    private let baseService: NetworkService
    private let tokenProvider: TokenProviding
    private let tokenStore: AuthTokenStoring
    private let refreshService: NetworkService
    private let refreshActor: TokenRefreshActor
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
                let retried = try await addAuthIfNeeded(to: endpoint)
                print("🔁 [AUTH SERVICE] Retrying request after refresh")
                do {
                    return try await baseService.request(retried)
                } catch {
                    if isUnauthorized(error) {
                        print("❌ [AUTH SERVICE] Retry also received 401 — session invalid")
                        throw NetworkError.tokenExpired
                    }
                    throw error
                }
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
                do {
                    try await baseService.request(retried)
                } catch {
                    if isUnauthorized(error) {
                        print("❌ [AUTH SERVICE] Retry also received 401 — session invalid")
                        throw NetworkError.tokenExpired
                    }
                    throw error
                }
            } else {
                throw error
            }
        }
    }

    // MARK: - Helpers

    private func isUnauthorized(_ error: Error) -> Bool {
        if case NetworkError.serverError(let code, _, _) = error, code == 401 {
            return true
        }
        if case NetworkError.tokenExpired = error { return true }
        if case NetworkError.unauthorized = error  { return true }
        return false
    }

    private func performRefresh() async throws {
        do {
            let newTokens = try await refreshActor.refresh {
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

            do {
                try tokenStore.save(newTokens)
                print("✅ [TOKEN REFRESH] New tokens persisted")
            } catch {
                print("❌ [TOKEN REFRESH] Failed to persist tokens: \(error.localizedDescription) — forcing logout")
                try? tokenStore.clear()
                await onForceLogout()
                throw NetworkError.tokenExpired
            }
        } catch {
            if case NetworkError.tokenExpired = error {
                throw error
            }
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
