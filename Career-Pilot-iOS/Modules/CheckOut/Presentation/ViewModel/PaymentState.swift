//
//  PaymentState.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
@MainActor
enum PaymentPhase: Equatable {
    case idle
    case creatingCheckout       // asking backend for checkoutUrl
    case awaitingUserPayment    // WebView is showing, user is entering card details
    case verifyingPayment       // WebView closed, polling backend for confirmation
    case succeeded
    case failed(String)
}
