import Foundation


import Foundation

enum InterviewError: Error, Equatable {
    case invalidState(current: InterviewSessionStatus, attempted: String)
    case questionLimitReached
    case interviewTimeExpired
    case sessionNotFound
    case networkUnavailable
    case sessionQuotaExceeded
    case serverError(String)
    case unknown(String)
}

extension InterviewError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidState(let current, let attempted):
            return "\(attempted) while the interview is in '\(current.rawValue)' state."
        case .questionLimitReached:
            return "You've reached the maximum number of questions for this interview."
        case .interviewTimeExpired:
            return "The interview time limit has been reached."
        case .sessionNotFound:
            return "No active interview session was found."
        case .networkUnavailable:
            return "Connection lost. Please check your network and try again."
        case .sessionQuotaExceeded:
            return "You have 0 sessions remaining. Subscribe or buy more to continue."
        case .serverError(let message):
            return "\(message)"
        case .unknown(let message):
            return message
        }
    }
}


extension InterviewError {
    static func map(_ error: Error) -> InterviewError {
        if let domainError = error as? InterviewError {
            return domainError // errors that i already throwed
        }

        if let networkError = error as? NetworkError {
            switch networkError {
            case.noInternet:
                return.networkUnavailable
            case .serverError(let statusCode, let data):
                switch statusCode {
                case 403:
                    return .sessionQuotaExceeded
                case 404:
                    return .sessionNotFound
                default:
                    let message = data
                        .flatMap { try? JSONDecoder().decode(APIErrorResponse.self, from: $0) }?
                        .message
                    return .serverError(message ?? "Request failed with status \(statusCode)")
                }
            // handle NetworkError's other cases here too, whatever they are
            default:
                return .networkUnavailable
            }
        }

        if (error as NSError).domain == NSURLErrorDomain {
            return .networkUnavailable
        }

        return .serverError(error.localizedDescription)
    }
}

struct APIErrorResponse: Decodable {
    let message: String?
}

struct HTTPStatusError: Error {
    let statusCode: Int
    let data: Data?
}
