import Foundation

enum ReportsEndpoint: APIEndpoint {
    static let defaultPageSize = 20

    case sessions(page: Int, size: Int = ReportsEndpoint.defaultPageSize)
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

    var queryParameters: [URLQueryItem]? {
        switch self {
        case .sessions(let page, let size):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
        default:
            return nil
        }
    }

    var method: HTTPMethod { .get }

    var requiresAuthentication: Bool { true }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}
