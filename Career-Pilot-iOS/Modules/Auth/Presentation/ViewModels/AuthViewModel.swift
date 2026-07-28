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
            let message = (error as? NetworkError)?.userMessage ?? error.localizedDescription
            toastManager.show(message, type: .error)
            return false
        }
    }
    
    func verifyOTP(_ verifyOtpInput: VerifyOTPInput) async -> VerifyOTPResult? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await verifyUseCase.execute(verifyOtpInput)
            return result
        } catch {
            let message = (error as? NetworkError)?.userMessage ?? error.localizedDescription
            toastManager.show(message, type: .error)
            return nil
        }
    }
}
