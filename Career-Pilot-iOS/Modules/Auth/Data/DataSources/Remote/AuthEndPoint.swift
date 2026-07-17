//
//  AuthEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

enum AuthEndPoint : APIEndpoint {
    case sendOTP(phoneNumber: String)
    
    var baseURL: String {
        "http://192.168.84.1:8080"
    }
    
    var path: String {
        switch self {
        case .sendOTP:
            return "/api/v1/otp/send"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .sendOTP:
                .post
        }
    }
    
    var body: Data? {
        switch self {
        case .sendOTP(let phoneNumber):
            return Self.encode(SendOTPRequest(phoneNumber: phoneNumber))
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

struct SendOTPRequest : Encodable {
    let phoneNumber: String
}
