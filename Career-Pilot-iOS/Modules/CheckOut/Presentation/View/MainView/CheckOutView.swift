//
//  CheckOutView.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 18/07/2026.
//
//  NOTE: This view is reused from two different navigation stacks
//  (Settings tab, and the video-upsell path off Home). It must NOT
//  hardcode which coordinator/Route type presented it — the caller
//  decides what "leave checkout" means for its own stack.
//

import SwiftUI


struct CheckOutView: View {
    let checkoutDisplayInfo: CheckoutDisplayInfo
    @State private var selectedPaymentMethod: String = "paymob"
    @StateObject var paymentVM: PaymentViewModel
    let onFinished: () -> Void

    var body: some View {
        Group {
            switch paymentVM.phase {
            case .idle, .creatingCheckout, .awaitingUserPayment:
                checkoutForm

            case .verifyingPayment, .succeeded, .failed:
                waitingContent
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: Binding(
            get: { paymentVM.checkoutURL != nil },
            set: { if !$0 { paymentVM.handleUserCancelled() } }
        )) {
            if let url = paymentVM.checkoutURL {
                PaymentWebView(url: url) { redirectURL in
                    paymentVM.handleRedirect(redirectURL)
                }
            }
        }
    }

    // MARK: - The normal checkout screen (summary + pay button)
    private var checkoutForm: some View {
        VStack(alignment: .leading) {
            CheckOutTopView()

            Spacer().frame(height: Spacing.s20)

            switch checkoutDisplayInfo {
            case .subscription(let plan, let monthlyPrice, _, let total, _):
                SubscribtionCheckoutView(
                    product: plan,
                    productPrice: monthlyPrice,
                    total: total
                )

            case .coinPack(let name, let pricePerPack, _, let total, _):
                CoinPackCheckOutView(
                    product: name,
                    productPrice: pricePerPack,
                    total: total
                )
            }

            Spacer().frame(height: Spacing.s20)

            Text("PAYMENT METHOD")
                .font(.size14Semibold)

            Spacer().frame(height: Spacing.s8)

            PaymentMethod(selectedMethod: $selectedPaymentMethod)

            Spacer()

            payButton
        }.toolbar(.hidden , for: .tabBar)
        .navigationTitle("Checkout")
        .padding(.horizontal, Spacing.s20)
        .background(Color.background.ignoresSafeArea())

    }

    @ViewBuilder
    private var payButton: some View {
        Button(action: {
            Task { await paymentVM.startPayment(item: checkoutDisplayInfo.checkoutItem) }
        }) {
            if paymentVM.phase == .creatingCheckout {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            } else {
                Text("Pay Now")
                    .font(.size16Bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
        }
        .background(Capsule().fill(Color.primary))
        .disabled(paymentVM.phase == .creatingCheckout)
    }

    // MARK: - Verifying / result content — takes over the WHOLE screen, not a cover
    private var waitingContent: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            switch paymentVM.phase {
            case .verifyingPayment:
                WaitingStateView(
                    icon: "creditcard",
                    state: .loading,
                    title: "Confirming your payment",
                    subtitle: "This usually takes a few seconds. Please don't close the app."
                )

            case .succeeded:
                WaitingStateView(
                    icon: "checkmark.circle",
                    tint: .activeColour,
                    state: .success,
                    title: "Payment successful!",
                    subtitle: "Your account has been updated.",
                    actionTitle: "Done",
                    action: { onFinished() }
                )

            case .failed(let message):
                WaitingStateView(
                    icon: "xmark.circle",
                    tint: .errorColour,
                    state: .failure,
                    title: "Payment could not be confirmed",
                    subtitle: message,
                    actionTitle: "Try Again",
                    action: { onFinished() }
                )

            default:
                EmptyView()
            }
        }
    }
}

//struct CheckOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckOutView(checkoutItem: .subscription(
//            plan: "Pro Monthly",
//            monthlyPrice: "200",
//            billingCycle: "Monthly",
//            total: "200"
//        ))
//
//        CheckOutView(checkoutItem: .coinPack(
//            name: "500 Coins",
//            pricePerPack: "119",
//            coinsIncluded: "500",
//            total: "119"
//    ))
//    }
//}
