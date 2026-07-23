//
//  SettingsRemote.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
protocol SettingsRemote{
    func logoutUser() async throws
    func getUserData() async ->User
    func getSubscription() async
    func getCoins() async
    func upgradeSubscription(upgradeSubscription : SubscriptionUpgrading) async throws -> PaymentResponse
}
