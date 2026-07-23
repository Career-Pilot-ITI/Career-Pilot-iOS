//
//  InterviewSessionEndPointes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation

enum InterviewSessionEndPointes: APIEndpoint {
    case startSession(StartInterviewSessionRequestDTO)
    case submitAnswer(SubmitAnswerRequestDTO)
    case resumeSession(sessionId: String)
    case getFeedback(sessionId: String)

    var baseURL: String {
        return "http://localhost:8080/api/v1"
    }

    var path: String {
        switch self {
        case .startSession:
            return "/interviews/sessions"
        case .submitAnswer(let submitRequest):
            return "/interviews/sessions/\(submitRequest.sessionId)/answer"
        case .resumeSession(let sessionId):
            return "/interviews/sessions/\(sessionId)/state"
        case .getFeedback(let sessionId):
            return "/interviews/sessions/\(sessionId)/feedback"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .startSession, .submitAnswer:
            return .post
        case .resumeSession, .getFeedback:
            return .get
        }
    }

    var headers: [String: String] {
        switch self {
        case .startSession, .submitAnswer:
            return ["Content-Type": "application/json"]
        case .resumeSession, .getFeedback:
            return [:]
        }
    }

    var body: Data? {
        switch self {
        case .startSession(let request):
            return Self.encode(request)
        case .submitAnswer(let request):
            return Self.encode(request)
        case .resumeSession, .getFeedback:
            return nil
        }
    }
}
