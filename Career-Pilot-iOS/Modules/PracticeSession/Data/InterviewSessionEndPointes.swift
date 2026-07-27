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
    
    var requiresAuthentication: Bool{
        return true
    }

    var baseURL: String {
        return "https://afd9-196-130-248-12.ngrok-free.app/"
    }

    var path: String {
        switch self {
        case .startSession:
            return "api/v1/interviews/sessions"
        case .submitAnswer(let submitRequest):
            return "api/v1/interviews/sessions/\(submitRequest.sessionId)/answer"
        case .resumeSession(let sessionId):
            return "api/v1/interviews/sessions/\(sessionId)/state"
        case .getFeedback(let sessionId):
            return "api/v1/interviews/sessions/\(sessionId)/feedback"
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
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWQiOjEsInN1YiI6InVzZXJfMTMyODM3IiwiaWF0IjoxNzg1MTYzOTkxLCJleHAiOjE3ODU1MjM5OTF9.JEPGUo5zmBHLYmRD1MUyPdXjUMhbti1jTQeUq_wOoCw"
            ]
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
