//
//  NetworkError.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case requestTimeout
    case unauthorized          // No token found
    case tokenExpired          // Token expired, need re-auth
    case decodingFailed(Error)
    case encodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternet:
            return "No internet connection"
        case .requestTimeout:
            return "Request timed out"
        case .unauthorized:
            return "Please log in again"
        case .tokenExpired:
            return "Session expired. Please log in again."
        case .decodingFailed:
            return "Failed to decode response"
        case .encodingFailed:
            return "Failed to encode request body"
        case .serverError(let code, _):
            return "Server error: \(code)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    /// A clear, non-technical message safe to display directly in the UI.
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Something went wrong. Please try again."
        case .noInternet:
            return "No internet connection. Please check your network and try again."
        case .requestTimeout:
            return "The request timed out. Please check your connection and try again."
        case .unauthorized:
            return "Your session is invalid. Please log in again."
        case .tokenExpired:
            return "Your session has expired. Please log in again."
        case .decodingFailed:
            return "We received an unexpected response. Please try again."
        case .encodingFailed:
            return "Something went wrong preparing your request. Please try again."
        case .serverError(let statusCode, let data):
            return Self.userMessage(for: statusCode, data: data)
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }

    /// Whether the user should be offered a retry action.
    var isRetryable: Bool {
        switch self {
        case .noInternet, .requestTimeout:
            return true
        case .serverError(let statusCode, _):
            return statusCode == 429 || (500...504).contains(statusCode)
        case .unknown:
            return true
        default:
            return false
        }
    }

    // MARK: - Private Helpers

    private static func userMessage(for statusCode: Int, data: Data?) -> String {
        switch statusCode {
        case 400:
            return "The information you entered doesn't look right. Please check and try again."
        case 401:
            return "Your code is invalid or has expired. Please request a new one."
        case 403:
            return "Access to this account is currently restricted. Please contact support."
        case 404:
            return "We couldn't find an account with this information."
        case 409:
            return "This phone number is already registered, or the code has already been used."
        case 422:
            return "Some of the information provided is invalid. Please review and try again."
        case 429:
            return rateLimitMessage(from: data)
        case 500...504:
            return "Our servers are experiencing issues. Please try again in a moment."
        default:
            return "Something went wrong. Please try again."
        }
    }

    private static func rateLimitMessage(from data: Data?) -> String {
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let retryAfter = json["retryAfter"] as? Int, retryAfter > 0 {
            return "You've made too many attempts. Please try again in \(retryAfter) seconds."
        }
        return "You've made too many attempts. Please wait a moment and try again."
    }
}
