//
//  PaymentViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 23/07/2026.
import Foundation
import Combine
@MainActor
final class PaymentViewModel: ObservableObject {
    @Published var phase: PaymentPhase = .idle
    @Published var checkoutURL: URL?
    
    private var merchantOrderId: String?
    private let verifyPaymentUseCase: VerifyPaymentUseCase
   private  var userRefreshData : RefreshUserDataUseCase
    private  var checkoutItem : CheckoutItem?
    private let checkoutUsecase:CheckoutUsecase
    private let maxPollAttempts = 10
    private let pollDelaySeconds: UInt64 = 2
    
    init( verifyPaymentUseCase: VerifyPaymentUseCase, checkoutUsecase: CheckoutUsecase ,  userRefreshData : RefreshUserDataUseCase) {
        self.verifyPaymentUseCase = verifyPaymentUseCase
        self.checkoutUsecase = checkoutUsecase
        self.userRefreshData = userRefreshData
    }
    
    // MARK: - Step 1: user taps "Pay"
    func startPayment(item: CheckoutItem) async {
        phase = .creatingCheckout
        checkoutItem = item
        do {
            let session = try await checkoutUsecase.execute(checkoutItem: item)
            merchantOrderId = session.merchantOrderId
            checkoutURL = URL(string  :session.checkoutUrl)
            phase = .awaitingUserPayment
        } catch {
            phase = .failed("Couldn't start checkout. Please try again.")
        }
    }
    
    // MARK: - Step 2: WebView detected the callback redirect
    func handleRedirect(_ url: URL) {
        checkoutURL = nil
        phase = .verifyingPayment
        Task {
            await pollForConfirmation()
        }
    }
    
    // MARK: - Alternative: user manually closed the WebView sheet
    func handleUserCancelled() {
        checkoutURL = nil
        phase = .failed("Payment was cancelled.")
    }
    
    // MARK: - Step 3: poll backend for the authoritative result
    private func pollForConfirmation() async {
        print("I visited teh poll For Confirmation")
          guard let item = checkoutItem else {
              phase = .failed("Missing payment reference.")
              return
          }
          
          for attempt in 1...maxPollAttempts {
              print("Poll attempt \(attempt) starting at \(Date())")

              if let isConfirmed = try? await verifyPaymentUseCase.execute(item: item), isConfirmed {
                  print("Confirmed on attempt \(attempt)")
                  phase = .succeeded
                  await userRefreshData.execute()
                  return
              }
              try? await Task.sleep(nanoseconds: pollDelaySeconds * 1_000_000_000)
          }
          
          phase = .failed("Could not confirm payment. Please check your account shortly.")
      }
    // MARK: - Reset, e.g. if the user wants to try again after a failure
    func reset() {
        phase = .idle
        checkoutURL = nil
        merchantOrderId = nil
    }
}



