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
    case scoreCVAgainstJob(id: Int)
    case optimizeCVForJob(id : Int)
    
    var path: String {
        switch self {
        case .getJobUrl:
            return "api/v1/workspaces/import/url"
        case .generateCoverLetter(let id):
            return "api/v1/workspaces/\(id)/cover-letter"
        case .scoreCVAgainstJob(let id):
            return "api/v1/workspaces/\(id)/score-cv"
        case .optimizeCVForJob(let id):
            return "api/v1/workspaces/\(id)/cv/optimize"
            
        }
    }
    
    var method: HTTPMethod { .post }
    
    var body: Data? {
        switch self {
            case .getJobUrl(let url): return Self.encode(url)
            case .generateCoverLetter : return nil
            case .scoreCVAgainstJob: return nil
            case .optimizeCVForJob: return nil
        }
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
   
    var requiresAuthentication: Bool { true }
    
}

