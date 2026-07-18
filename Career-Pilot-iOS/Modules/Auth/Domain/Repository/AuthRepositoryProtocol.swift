//
//  Repo.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/07/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func sendOTP(for phoneNumber: String) async throws
    func verifyOTP(for phoneNumber: String, with code: String) async throws -> VerifyOTPResult
}
