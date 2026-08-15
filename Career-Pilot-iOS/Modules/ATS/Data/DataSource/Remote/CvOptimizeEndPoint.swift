//
//  CvOptimizeEndPoint.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation

enum CvOptimizeEndPoint: APIEndpoint {
    case triggerOptimize(workspaceId: Int)
    case pollJobStatus(workspaceId: Int, jobId: Int)
    
    var path: String {
        switch self {
        case .triggerOptimize(let workspaceId):
            return "api/v1/workspaces/\(workspaceId)/cv/optimize"
        case .pollJobStatus(let workspaceId, let jobId):
            return "api/v1/workspaces/\(workspaceId)/ai-jobs/\(jobId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .triggerOptimize:
            return .post
        case .pollJobStatus:
            return .get
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
