//
//  File.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 26/07/2026.
//

import Foundation
protocol VerifyPaymentUseCase {
    func execute(item: CheckoutItem) async throws -> Bool
}

struct VerifyPaymentUseCaseImp: VerifyPaymentUseCase {
    let getUserData: GetUserDataUseCase
    let checkoutRepo : CheckOutRepo
    
    func execute(item: CheckoutItem) async throws -> Bool {
        switch item {
        case .subscription(let planType):
            let subscription = try await checkoutRepo.getUserSubscription()
            print("subscription = \(subscription.tier == planType) ")
            return subscription.tier != planType
            
        case .coinPack(let coinsAmount):
            let localUser = try await getUserData.execute()
            let currentBalance = try await checkoutRepo.getUserCoin()
            print("User local balance \(localUser.coinBalance)")
            print("user Current Balance \(currentBalance)")
            return currentBalance > (Int(localUser.coinBalance)! )
        }
    }
}
