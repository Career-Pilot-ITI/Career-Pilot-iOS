import Foundation


enum InterviewError: Error, Equatable {
    case invalidState(current: InterviewSessionStatus, attempted: String)
    case questionLimitReached
    case interviewTimeExpired
    case sessionNotFound
    case networkUnavailable
    case repositoryError(String)
    case unknown(String)
}

extension InterviewError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidState(let current, let attempted):
            return "Can't \(attempted) while the interview is in '\(current.rawValue)' state."
        case .questionLimitReached:
            return "You've reached the maximum number of questions for this interview."
        case .interviewTimeExpired:
            return "The interview time limit has been reached."
        case .sessionNotFound:
            return "No active interview session was found."
        case .networkUnavailable:
            return "Connection lost. Please check your network and try again."
        case .repositoryError(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}

extension InterviewError {
    static func map(_ error: Error) -> InterviewError {
        if let domainError = error as? InterviewError {
            return domainError
        }
        if (error as NSError).domain == NSURLErrorDomain {
            return .networkUnavailable
        }
        return .repositoryError(error.localizedDescription)
    }
}
