//
//  TokenProvider.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation

protocol TokenProviding {
    func getAccessToken() async throws -> String
}

final class AuthTokenProvider: TokenProviding {
    private let tokenStore: AuthTokenStoring
    
    init(tokenStore: AuthTokenStoring) {
        self.tokenStore = tokenStore
    }
    
    func getAccessToken() async throws -> String {
        guard let tokens = try tokenStore.loadTokens() else {
            throw NetworkError.unauthorized
        }
        
        print("------------------------------------------")
        print("🔑 [TOKENS]: \(tokens)")
        print("------------------------------------------")
        
        let isExpired = tokens.expiresIn <= 120
        
        if isExpired {
            try tokenStore.clear()
            throw NetworkError.tokenExpired
        }
        
        return tokens.accessToken
    }
}
