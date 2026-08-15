//
//  CvOptimizeEndPoint.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation

enum CvOptimizeEndPoint: APIEndpoint {
    case optimize(workspaceId: Int)
    
    var path: String {
        switch self {
        case .optimize(let workspaceId):
            return "api/v1/workspaces/\(workspaceId)/cv/optimize"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .optimize:
            return .post
        }
    }
    
    var body: Data? { nil }
    
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
    
    var requiresAuthentication: Bool { true }
}
