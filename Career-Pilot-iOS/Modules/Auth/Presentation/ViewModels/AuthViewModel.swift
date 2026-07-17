//
//  AuthViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz Osama on 17/07/2026.
//

import Foundation
@MainActor
class AuthViewModel: ObservableObject {
    private let useCase: SendOTPUseCase
    private let toastManager: ToastManager
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(useCase: SendOTPUseCase, toastManager: ToastManager) {
        self.useCase = useCase
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
            try await useCase.execute(phoneNumber)
            return true
        } catch {
            toastManager.show(error.localizedDescription, type: .error)
            return false
        }
    }
}
