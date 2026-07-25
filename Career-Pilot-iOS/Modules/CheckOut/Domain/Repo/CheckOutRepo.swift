//
//  CheckOutRepo.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
protocol CheckOutRepo{
    func upgradeSubscription(upgradeSubscription: SubscriptionUpgrading) async throws -> PaymentResponse
    func buyingCoins (coinsRequest: CointRequestedDTo) async throws -> PaymentResponse 
}
