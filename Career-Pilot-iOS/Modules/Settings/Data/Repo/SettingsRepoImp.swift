//
//  SettingsRepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class SettingsRepoImp : SettingsRepo  {
    var remote : SettingsRemote
    init(remote: SettingsRemote) {
        self.remote = remote
    }
    func fetchUserData() async -> User {
        return await remote.getUserData()
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
    
    func logout() async throws{
        do{
            try await remote.logoutUser()
        }catch{
            print("error in the repor for the logout \(error)")
            throw error
        }
    }
    
    func getSubscription()  -> [SubscriptionPlan] {
        return     [
            SubscriptionPlan(type: .free, price: "0", label: "Free Plan",
                 features: ["3 sessions / month", "Basic score report", "Standard feedback"]),
            SubscriptionPlan(type: .plus, price: "199", label: "Plus Plan",
                 features: ["12 sessions / month", "Detailed radar chart", "Priority AI feedback", "Coaching tips library"]),
            SubscriptionPlan(type: .pro, price: "349", label: "Pro Plan",
                 features: ["Unlimited sessions", "Instant feedback", "All tracks unlocked", "1:1 coaching session"])
        ]
        
    }
    
    func getCoins() -> [CoinPack] {
        return   [
            CoinPack(coinsValue: "100", price: "29", subTitle: "Great for trying premium features"),
            CoinPack(coinsValue: "500", price: "119", subTitle: "Best value for regular practitioners"),
            CoinPack(coinsValue: "1,000", price: "199", subTitle: "Power users & intensive prep")
        ]
    }
   
    
    
}
