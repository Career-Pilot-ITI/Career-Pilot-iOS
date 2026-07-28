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
        print("Start mapping the error")
        if let domainError = error as? InterviewError {
            print("-------\(domainError.errorDescription ?? "no Error")")
            return domainError // errors that i already throwed
        }

        if let networkError = error as? NetworkError {
            switch networkError {
            case.unauthorized,.tokenExpired:
                return.sessionNotFound
            case.noInternet:
                return.networkUnavailable
            case .serverError(let statusCode,_):
                switch statusCode {
                case 403:
                    return .sessionQuotaExceeded
                case 404:
                    return .sessionNotFound
                default:
                    return .serverError("Something went wrong. Please try again.")
                }
            case.invalidURL,.decodingFailed(_),.encodingFailed(_):
                return.unknown("Sorry For That\nServer problem, please contact support.")
            default:
                print("Defualt")
                return .networkUnavailable
            }
        }

        if (error as NSError).domain == NSURLErrorDomain {
            return .networkUnavailable
        }

        return .serverError(error.localizedDescription)
    }
}
