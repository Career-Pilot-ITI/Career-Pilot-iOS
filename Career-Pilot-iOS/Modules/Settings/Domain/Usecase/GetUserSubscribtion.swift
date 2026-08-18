//
//  GetUserSubscribtion.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 28/07/2026.
//

import Foundation
class GetUserSubscribtion {
    var settingsRepo : SettingsRepo
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    func execute() async  -> UserSubscribtionDomain{
             return try await settingsRepo.getUserSubscription()
       
    }

}

