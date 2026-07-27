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
    func execute() -> [SubscriptionPlan]{
        settingsRepo.getSubscription()
    }
}
