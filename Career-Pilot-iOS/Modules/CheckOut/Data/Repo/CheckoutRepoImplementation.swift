//
//  CheckoutRepoImplementation.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
class CheckoutRepoImplementation  : CheckOutRepo{

  
    

    

    
    var remote : CheckoutRemoteDataSource
    init(remote: CheckoutRemoteDataSource) {
        self.remote = remote
    }
    func getUserCoin() async throws -> Int {
        do{
            let response = try await remote.getUserCoin()
            return response.balance
            
        }catch{
            print("Upgrade error in the repo \(error)")
            throw error
        }
    }
    
    func getUserSubscription() async throws -> CurrentSubscriptionDomain {
        do{
            let response = try await remote.getUserSubscription()
            return response.toDomain()
            
        }catch{
            print("Upgrade error in the repo \(error)")
            throw error
        }
    }
    
    func upgradeSubscription(upgradeSubscription: SubscriptionUpgrading) async throws -> PaymentResponse {
        do{
            let response = try await remote.upgradeSubscription(upgradeSubscription: upgradeSubscription)
            return response
            
        }catch{
            print("Upgrade error in the repo \(error)")
            throw error
        }
        
    }
    func buyingCoins(coinsRequest: CointRequestedDTo) async throws -> PaymentResponse {
        do{
            let response = try await remote.buyingCoins(coinRequest: coinsRequest)
            return response
            
        }catch{
            print("Upgrade error in the repo \(error)")
            throw error
        }
    }
}
