//
//  GetUpgradeSubscription.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
class UpgradeUserSubscription{
    var checkoutRepo : CheckOutRepo
    init(checkoutRepo: CheckOutRepo) {
        self.checkoutRepo = checkoutRepo
    }
    func execute(upgradeSubscription :SubscriptionUpgrading)async throws -> PaymentResponse {
        do{
          return  try await checkoutRepo.upgradeSubscription(upgradeSubscription: upgradeSubscription )
        }catch{
            print("error for subscripton \(error)")
            throw error
            
        }
 
    }
}
