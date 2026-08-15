import Foundation

enum InterviewError: Error, Equatable {
    case invalidState(current: InterviewSessionStatus, attempted: String)
    case questionLimitReached
    case interviewTimeExpired
    case sessionNotFound
    case unauthorized
    case networkUnavailable
    case sessionQuotaExceeded
    case serverError(String)
    case unknown(String)
}

// MARK: - LocalizedError
extension InterviewError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidState(let current, let attempted):
            return "\(attempted) while the interview is in '\(current.rawValue)' state."
        case .questionLimitReached:
            return "You've reached the maximum number of questions for this interview."
        case .interviewTimeExpired:
            return "The interview time limit has been reached."
        case .unauthorized:
            return "Your session has expired. Please log in again to continue."
        case .sessionNotFound:
            return "No active interview session was found."
        case .networkUnavailable:
            return "Connection lost. Please check your network and try again."
        case .sessionQuotaExceeded:
            return "You have 0 sessions remaining. Subscribe or buy more to continue."
        case .serverError(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}

// MARK: - Error Mapping
extension InterviewError {
    static func map(_ error: Error) -> InterviewError {
        print("Start mapping the error")
        
        // 1. Pass through existing domain errors
        if let domainError = error as? InterviewError {
            print("Domain Error: \(domainError.errorDescription ?? "No Description")")
            return domainError
        }

        // 2. Map NetworkError cases
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized, .tokenExpired:
                print("unauthorized")
                return .unauthorized
                
            case .noInternet, .requestTimeout:
                return .networkUnavailable
                
            case .serverError(let statusCode, _, _):
                switch statusCode {
                case 401...403:
                    return .unauthorized
                case 404:
                    return .sessionNotFound
                case 429:
                    return.sessionQuotaExceeded	
                default:
                    return .serverError(networkError.userMessage)
                }
                
            case .decodingFailed, .encodingFailed, .invalidURL:
                return .unknown("Server problem. Please contact support.")
                
            case .unknown(let underlyingError):
                return .unknown(underlyingError.localizedDescription)
            }
        }

        // 3. Map System/Foundation URL errors
        if (error as NSError).domain == NSURLErrorDomain {
            return .networkUnavailable
        }

        // 4. Default fallback
        return .serverError(error.localizedDescription)
    }
}
