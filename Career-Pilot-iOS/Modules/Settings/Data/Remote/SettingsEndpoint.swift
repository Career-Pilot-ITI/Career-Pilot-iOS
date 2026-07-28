//
//  SettingsEndpoint.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
enum SettingsEndpoint : APIEndpoint{
    case logout
    case getUserData
    case getSubscribtionsPrice
    
    var path: String{
        switch self {
        case.getUserData:
            return "/api/v1/profile"
        case .getSubscribtionsPrice:
            return "/api/v1/subscriptions/tiers"
        case .logout:
            return "/api/v1/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case.getUserData :
            return .get
            
        case .getSubscribtionsPrice:
            return .get
            
        case .logout:
            return .post
            
        }
    }
    var body: Data? {
         return nil
        }
    var requiresAuthentication: Bool {
            true
        }
    var headers: [String: String] {
        let tokenString: String
        do {
            
            if let tokens = try KeychainAuthTokenStore().loadTokens() {
                tokenString = tokens.accessToken
            } else {
                tokenString = ""
            }
        } catch {
            tokenString = ""
        }
        
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(tokenString)"
        ]
    }
    

    
    
    
    
}
