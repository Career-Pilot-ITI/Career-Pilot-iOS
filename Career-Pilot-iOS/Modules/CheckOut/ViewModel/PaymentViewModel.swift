//
//  PaymentViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 23/07/2026.
//import Foundation
//@MainActor
//final class PaymentViewModel: ObservableObject {
//    @Published var state: LoadState<PaymentResult> = .idle
//    @Published var checkoutURL: URL?
//
//    private let createCheckoutSessionUseCase:      CreateCheckoutSessionUseCase
//    private let verifyPaymentUseCase: VerifyPaymentUseCase
//
//    init(createCheckoutSessionUseCase: CreateCheckoutSessionUseCase, verifyPaymentUseCase: VerifyPaymentUseCase) {
//        self.createCheckoutSessionUseCase = createCheckoutSessionUseCase
//        self.verifyPaymentUseCase = verifyPaymentUseCase
//    }
//
//    func startPayment(item: CheckoutItem, method: PaymentMethodType) async {
//        state = .loading
//        do {
//            let url = try await createCheckoutSessionUseCase.execute(item: item, method: method)
//            checkoutURL = url
//        } catch {
//            state = .failure(error)
//        }
//    }
//
//    func handleRedirect(_ url: URL) {
//        checkoutURL = nil
//
//        guard let transactionId = extractTransactionId(from: url) else {
//            state = .failure(PaymentError.invalidCallback)
//            return
//        }
//
//        Task {
//            await verifyPayment(transactionId: transactionId)
//        }
//    }
//
//    private func verifyPayment(transactionId: String) async {
//        state = .loading
//        do {
//            let result = try await verifyPaymentUseCase.execute(transactionId: transactionId)
//            state = .success(result)
//        } catch {
//            state = .failure(error)
//        }
//    }
//
//    private func extractTransactionId(from url: URL) -> String? {
//        URLComponents(url: url, resolvingAgainstBaseURL: false)?
//            .queryItems?
//            .first(where: { $0.name == "transactionId" })?
//            .value
//    }
//}
