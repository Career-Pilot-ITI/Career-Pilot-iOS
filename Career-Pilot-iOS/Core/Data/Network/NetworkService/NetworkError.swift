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
}
