//
//  ATSEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

enum ATSEndPoint : APIEndpoint {
    case getJobUrl(url: String)
    
    var path: String {
        switch self {
        case .getJobUrl:
            return "api/v1/workspaces/import/url"
        }
    }
    
    var method: HTTPMethod { .post }
    
    var body: Data? {
        switch self {
        case .getJobUrl(let url):
            return Self.encode(url)
        }
    }
    
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    var requiresAuthentication: Bool { true }
    
}

