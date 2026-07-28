//
//  ReportsEndpoint.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

enum ReportsEndpoint: APIEndpoint {
    case sessions
    case sessionDetail(sessionId: Int)
    case sessionQuestions(sessionId: Int)
    case questionDetail(sessionId: Int, questionId: Int)
    case sessionFeedback(sessionId: Int)
    
    var path: String {
        switch self {
        case .sessions:
            return "api/v1/interviews/sessions"
        case .sessionDetail(let sessionId):
            return "api/v1/interviews/sessions/\(sessionId)"
        case .sessionQuestions(let sessionId):
            return "api/v1/interviews/sessions/\(sessionId)/questions"
        case .questionDetail(let sessionId, let questionId):
            return "api/v1/interviews/sessions/\(sessionId)/questions/\(questionId)"
        case .sessionFeedback(let sessionId):
            return "api/v1/interviews/sessions/\(sessionId)/feedback"
        }
    }
    
    
    var method: HTTPMethod { .get }
        
    var requiresAuthentication: Bool {true}
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

