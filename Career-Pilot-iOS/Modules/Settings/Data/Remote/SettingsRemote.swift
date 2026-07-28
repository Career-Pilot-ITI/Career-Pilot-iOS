//
//  SettingsRemote.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
protocol SettingsRemote{
    func logoutUser() async throws
    func getUserData() async throws ->UserSettingsDTO
    func getSubscription() async throws -> SubscribitonsPriceDTO
    func getCoins() async

}
