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
