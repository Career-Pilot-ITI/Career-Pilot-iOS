//
//  PaymentViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 23/07/2026.
//

import Foundation
import Combine

@MainActor
final class PaymentViewModel: ObservableObject {
    @Published var phase: PaymentPhase = .idle
    @Published var checkoutURL: URL?
    
    private var merchantOrderId: String?
    private let verifyPaymentUseCase: VerifyPaymentUseCase
    private var checkoutItem: CheckoutItem?
    private let checkoutUsecase: CheckoutUsecase
    private let maxPollAttempts = 10
    private let pollDelaySeconds: UInt64 = 2
    private let userSession: UserSession
    
    init(verifyPaymentUseCase: VerifyPaymentUseCase, checkoutUsecase: CheckoutUsecase, userSession: UserSession) {
        self.verifyPaymentUseCase = verifyPaymentUseCase
        self.checkoutUsecase = checkoutUsecase
        self.userSession = userSession
    }
    
    // MARK: - Step 1: User taps "Pay"
    func startPayment(item: CheckoutItem) async {
        phase = .creatingCheckout
        checkoutItem = item
        do {
            let session = try await checkoutUsecase.execute(checkoutItem: item)
            merchantOrderId = session.merchantOrderId
            checkoutURL = URL(string: session.checkoutUrl)
            phase = .awaitingUserPayment
        } catch {
            phase = .failed("Couldn't start checkout. Please try again.")
        }
    }
    
    // MARK: - Step 2: WebView detected the callback redirect
    func handleRedirect(_ url: URL) {
        // Prevent double execution if already verifying or succeeded
        guard phase != .verifyingPayment && phase != .succeeded else { return }
        
        phase = .verifyingPayment
        checkoutURL = nil // Closes the sheet
        
        Task {
            await pollForConfirmation()
        }
    }
    
    // MARK: - Alternative: User manually closed the WebView sheet
    func handleUserCancelled() {
        // 🔒 FIX: Do NOT mark as failed if we are already verifying or already succeeded!
        guard phase == .awaitingUserPayment || phase == .creatingCheckout else { return }
        
        checkoutURL = nil
        phase = .failed("Payment was cancelled.")
    }
    
    // MARK: - Step 3: Poll backend for the authoritative result
    private func pollForConfirmation() async {
        guard let item = checkoutItem else {
            phase = .failed("Missing payment reference.")
            return
        }
        
        for attempt in 1...maxPollAttempts {
            if Task.isCancelled { return }
            
            // Try to verify payment
            do {
                let isConfirmed = try await verifyPaymentUseCase.execute(item: item)
                if isConfirmed {
                    phase = .succeeded
                    
                    do {
                        try await userSession.reload()
                    } catch {
                        print("⚠️ Error reloading user session: \(error)")
                    }
                    return // ✅ Success! Exit polling immediately without throwing errors.
                }
            } catch {
                print("Polling attempt \(attempt)/\(maxPollAttempts) pending or failed: \(error)")
                // Do NOT set phase = .failed here! Keep retrying until maxPollAttempts.
            }
            
            // Wait before next retry if not at the end
            if attempt < maxPollAttempts {
                do {
                    try await Task.sleep(nanoseconds: pollDelaySeconds * 1_000_000_000)
                } catch {
                    print("Sleep cancelled: \(error)")
                    return // Task was cancelled, exit quietly
                }
            }
        }
        
        // ❌ ONLY set .failed if ALL maxPollAttempts failed without success
        if !Task.isCancelled && phase != .succeeded {
            phase = .failed("Could not confirm payment. Please check your account shortly.")
        }
    }
    
    // MARK: - Reset (e.g., if the user wants to try again after a failure)
    func reset() {
        phase = .idle
        checkoutURL = nil
        merchantOrderId = nil
    }
}


