//
//  GetUpgradeSubscription.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
class CheckoutUsecase{
    var checkoutRepo : CheckOutRepo
    init(checkoutRepo: CheckOutRepo) {
        self.checkoutRepo = checkoutRepo
    }
    func execute(checkoutItem :CheckoutItem)async throws -> PaymentResponse {
        switch checkoutItem {
        case .coinPack(let plan) :
            do{
              return  try await checkoutRepo.buyingCoins(coinsRequest: CointRequestedDTo(coinPackSize: plan, currency: "EGP", method: "card"))
            }catch{
                print("error for subscripton \(error)")
                throw error
                
            }
        case .subscription(let planType):
            do{
                
                return  try await checkoutRepo.upgradeSubscription(upgradeSubscription: SubscriptionUpgrading(tier: planType.rawValue, currency: "EGP", method: "card") )
            }catch{
                print("error for subscripton \(error)")
                throw error}
            
        }
   
 
    }
}
