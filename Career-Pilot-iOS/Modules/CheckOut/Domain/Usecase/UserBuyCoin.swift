//
//  UserBuyCoin.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
class UserBuyCoins {
    var checkoutRepo : CheckOutRepo
    init(checkoutRepo: CheckOutRepo) {
        self.checkoutRepo = checkoutRepo
    }
    func execute(cointRequestedDTo :CointRequestedDTo)async throws -> PaymentResponse {
        do{
          return  try await checkoutRepo.buyingCoins(coinsRequest:cointRequestedDTo )
        }catch{
            print("error for subscripton \(error)")
            throw error
            
        }
 
    }
}
