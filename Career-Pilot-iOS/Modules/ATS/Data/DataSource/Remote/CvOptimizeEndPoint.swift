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
        return ["Content-Type": "application/json"]
    }
    
    var requiresAuthentication: Bool { true }
}
