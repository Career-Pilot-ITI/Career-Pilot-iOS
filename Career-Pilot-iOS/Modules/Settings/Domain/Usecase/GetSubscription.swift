//
//  GetSubscription.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class GetSubscribtionPlan{
    var settingsRepo : SettingsRepo
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    func execute() async throws -> [SubscriptionPlan]{
        do {
           return try await settingsRepo.getSubscription()
        }
        catch{
            print("There is error")
            throw error
        }
    }
}
