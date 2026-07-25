//
//  ProfileProtocolRepo.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import Foundation
protocol  SettingsRepo{
    func fetchUserData() async throws -> UserSettingsDomain
    func logout() async throws
    func getSubscription() -> [SubscriptionPlan]
    func getCoins() ->[CoinPack]
}
