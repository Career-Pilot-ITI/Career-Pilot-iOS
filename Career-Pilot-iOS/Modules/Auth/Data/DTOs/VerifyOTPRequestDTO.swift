//
//  VerifyOTPRequestDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation

struct VerifyOTPRequestDTO: Encodable {
    let phoneNumber: String
    let otp: String
}
