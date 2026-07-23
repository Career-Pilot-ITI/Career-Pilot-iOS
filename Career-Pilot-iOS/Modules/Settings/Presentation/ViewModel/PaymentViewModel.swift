////
////  PaymentViewMdoel.swift
////  Career-Pilot-iOS
////
////  Created by Eyad waleed on 22/07/2026.
////
//
//import Foundation
//@MainActor
//final class PaymentViewModel: ObservableObject {
//    @Published var state: LoadState<PaymentResult> = .idle
//    @Published var checkoutURL: URL?
//    @Published var selectedMethod: PaymentMethodType = .paymob
//    
//    private let createCheckoutSessionUseCase: CreateCheckoutSessionUseCase
//    
//    init(createCheckoutSessionUseCase: CreateCheckoutSessionUseCase) {
//        self.createCheckoutSessionUseCase = createCheckoutSessionUseCase
//    }
//    
//    func startPayment(item: CheckoutItem) async {
//        state = .loading
//        do {
//            let url = try await createCheckoutSessionUseCase.execute(item: item, method: selectedMethod)
//            checkoutURL = url
//        } catch {
//            state = .failure(error)
//        }
//    }
//    
//    func handleRedirect(_ url: URL) {
//        checkoutURL = nil
//        if url.absoluteString.contains("status=success") {
//            state = .success(PaymentResult(transactionId: extractTransactionId(from: url)))
//        } else {
//            state = .failure(PaymentError.cancelledOrFailed)
//        }
//    }
//    
//    private func extractTransactionId(from url: URL) -> String {
//        URLComponents(url: url, resolvingAgainstBaseURL: false)?
//            .queryItems?
//            .first(where: { $0.name == "transactionId" })?
//            .value ?? ""
//    }
//}
//
//enum PaymentError: Error {
//    case cancelledOrFailed
//}
//
//struct PaymentResult {
//    let transactionId: String
//}
//
//enum PaymentMethodType: String {
//    case paymob, applePay
//}
