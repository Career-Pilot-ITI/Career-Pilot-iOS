//
//  ATSEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

enum ATSEndPoint : APIEndpoint {
    case getJobUrl(url: String)
    case generateCoverLetter(id: Int)
    
    var path: String {
        switch self {
        case .getJobUrl:
            return "api/v1/workspaces/import/url"
        case .generateCoverLetter(let id):
            return "api/v1/workspaces/\(id)/cover-letter"
        }
    }
    
    var method: HTTPMethod { .post }
    
    var body: Data? {
        switch self {
            case .getJobUrl(let url): return Self.encode(url)
            case .generateCoverLetter(let id) : return nil
        }
    }
    
    var headers: [String: String] {
        let tokenString: String
        do {
            
            if let tokens = try KeychainAuthTokenStore().loadTokens() {
                print("Token is \(tokens.accessToken)")
                tokenString = tokens.accessToken
                
            } else {
                tokenString = ""
                print("Token is not found")

            }
        } catch {
            tokenString = ""
        }
        
        return [
              "Content-Type": "application/json",
              "Authorization": "Bearer \(tokenString)"
        ]

    }
   
    var requiresAuthentication: Bool { true }
    
}

