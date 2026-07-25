//
//  SettingsRemote.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
protocol SettingsRemote{
    func logoutUser() async throws
    func getUserData() async throws ->UserDTO
    func getSubscription() async
    func getCoins() async

}
