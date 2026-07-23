//
//  UpgradeUserSubsription.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class UpgradeUserSubscription{
    var settingsRepo : SettingsRepo
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    func execute(upgradeSubscription :SubscriptionUpgrading)async throws -> PaymentResponse {
        do{
          return  try await settingsRepo.upgradeSubscription(upgradeSubscription: upgradeSubscription )
        }catch{
            print("error for subscripton \(error)")
            throw error
            
        }
 
    }
}
