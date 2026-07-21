//
//  InterviewSessionEndPointes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation

enum InterviewSessionEndPointes: APIEndpoint {
    case startSession(InterviewConfiguration)
    case submitAnswer(SubmitAnswerRequest)
    case resumeSession(sessionId: String)
    case finishInterview(FinishInterviewRequest)
    case cancelSession(sessionId: String)

    var baseURL: String {
        
        return "https://api.careerpilot.app/v1"
    }

    var path: String {
        switch self {
        case .startSession:
            return "/interview-sessions"
        case .submitAnswer(let request):
            return "/interview-sessions/\(request.session.id)/answers"
        case .resumeSession(let sessionId):
            return "/interview-sessions/\(sessionId)/resume"
        case .finishInterview(let request):
            return "/interview-sessions/\(request.sessionID)/finish"
        case .cancelSession(let sessionId):
            return "/interview-sessions/\(sessionId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .startSession:
            return .post
        case .submitAnswer:
            return .post
        case .resumeSession:
            return .get
        case .finishInterview:
            return .post
        case .cancelSession:
            return .delete
        }
    }


//    var body: Encodable? {
//        switch self {
//        case .startSession(let configuration):
//            return configuration
//        case .submitAnswer(let request):
//            return request
//        case .resumeSession, .cancelSession:
//            return nil
//        case .finishInterview(let request):
//            return request
//        }
//    }
}
