//
//  AuthViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz Osama on 17/07/2026.
//

import Foundation
@MainActor
class AuthViewModel: ObservableObject {
    private let sendUseCase: SendOTPUseCase
    private let verifyUseCase : VerifyOTPUseCase
    private let toastManager: ToastManager
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(sendUseCase: SendOTPUseCase, verifyUseCase : VerifyOTPUseCase, toastManager: ToastManager) {
        self.sendUseCase = sendUseCase
        self.verifyUseCase = verifyUseCase
        self.toastManager = toastManager
    }
    
    @discardableResult
    func sendOTP(for phoneNumber: String) async -> Bool {
        guard !phoneNumber.isEmpty else {
            toastManager.show("Please enter a valid phone number.", type: .error)
            return false
        }

        isLoading = true
        defer { isLoading = false }
        do {
            try await sendUseCase.execute(phoneNumber)
            return true
        } catch {
            toastManager.show(error.localizedDescription, type: .error)
            return false
        }
    }
    
    @discardableResult
    func verifyOTP(_ verifyOtpInput: VerifyOTPInput) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await verifyUseCase.execute(verifyOtpInput)
            return true
        } catch(let error) {
            toastManager.show(error.localizedDescription, type: .error)
            return false
        }
    }
}
