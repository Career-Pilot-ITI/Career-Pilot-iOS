//
//  CheckoutRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
protocol CheckoutRemoteDataSource {
    func upgradeSubscription(upgradeSubscription : SubscriptionUpgrading) async throws -> PaymentResponse
    func buyingCoins(coinRequest: CointRequestedDTo) async throws -> PaymentResponse
}
