//
//  AuthEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

enum AuthEndPoint: APIEndpoint {
    case sendOTP(phoneNumber: String)
    case verifyOTP(phoneNumber: String, code: String)
    case refreshToken(refreshToken: String)

    var path: String {
        switch self {
        case .sendOTP:
            return "api/v1/otp/send"
        case .verifyOTP:
            return "api/v1/otp/verify"
        case .refreshToken:
            return "api/v1/auth/refresh"
        }
    }

    var method: HTTPMethod { .post }

    var body: Data? {
        switch self {
        case .sendOTP(let phoneNumber):
            return Self.encode(SendOTPRequest(phoneNumber: phoneNumber))
        case .verifyOTP(let phoneNumber, let code):
            return Self.encode(VerifyOTPRequest(phoneNumber: phoneNumber, code: code))
        case .refreshToken(let token):
            return Self.encode(RefreshTokenRequest(refreshToken: token))
        }
    }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    /// The refresh call must NOT carry the expired access token.
    var requiresAuthentication: Bool { false }
}

struct SendOTPRequest: Encodable {
    let phoneNumber: String
}

struct VerifyOTPRequest: Encodable {
    let phoneNumber: String
    let code: String
}

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}
