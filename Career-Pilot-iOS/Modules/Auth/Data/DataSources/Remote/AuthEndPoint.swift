//
//  AuthEndPoint.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

enum AuthEndPoint : APIEndpoint {
    case sendOTP(phoneNumber: String)
    case verifyOTP(phoneNumber: String ,code: String)
    
    
    var path: String {
        switch self {
        case .sendOTP:
            return "api/v1/otp/send"
        case .verifyOTP:
            return "api/v1/otp/verify"
        }
    }
    
    var method: HTTPMethod { .post }
    
    var body: Data? {
        switch self {
        case .sendOTP(let phoneNumber):
            return Self.encode(SendOTPRequest(phoneNumber: phoneNumber))
        case .verifyOTP(let phoneNumber, let code):
            return Self.encode(VerifyOTPRequest(phoneNumber: phoneNumber,code: code))
        }
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
}

struct SendOTPRequest : Encodable {
    let phoneNumber: String
}

struct VerifyOTPRequest : Encodable {
    let phoneNumber: String
    let code : String
}
