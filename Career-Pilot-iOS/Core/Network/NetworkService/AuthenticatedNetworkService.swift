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
    
    init(baseService: NetworkService, tokenProvider: TokenProviding) {
        self.baseService = baseService
        self.tokenProvider = tokenProvider
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let authenticated = try await addAuthIfNeeded(to: endpoint)
        return try await baseService.request(authenticated)
    }
    
    func request(_ endpoint: APIEndpoint) async throws {
        let authenticated = try await addAuthIfNeeded(to: endpoint)
        try await baseService.request(authenticated)
    }
    
    private func addAuthIfNeeded(to endpoint: APIEndpoint) async throws -> APIEndpoint {
        guard endpoint.requiresAuthentication else {
            return endpoint  
        }
        
        let token = try await tokenProvider.getAccessToken()
        return AuthEndpointDecorator(base: endpoint, token: token)
    }
}

private struct AuthEndpointDecorator: APIEndpoint {
    let base: APIEndpoint
    let token: String
    
    var baseURL: String { base.baseURL }
    var path: String { base.path }
    var method: HTTPMethod { base.method }
    var queryParameters: [URLQueryItem]? { base.queryParameters }
    var body: Data? { base.body }
    
    var requiresAuthentication: Bool { base.requiresAuthentication }
    
    var headers: [String: String] {
        var merged = base.headers
        merged["Authorization"] = "Bearer \(token)"
        return merged
    }
}
