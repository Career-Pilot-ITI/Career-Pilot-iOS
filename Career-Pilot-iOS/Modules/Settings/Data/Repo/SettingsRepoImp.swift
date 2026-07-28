//
//  SettingsRepoImp.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class SettingsRepoImp : SettingsRepo  {
    var remote : SettingsRemote
    var local : SettingsLocalDataSource
    var authToken : AuthTokenStoring
    init(remote: SettingsRemote ,  local : SettingsLocalDataSource , authToken : AuthTokenStoring) {
        self.remote = remote
        self.local = local
        self.authToken = authToken
    }
    func fetchUserData() async throws -> UserSettingsDomain {
        if let cachedUser = try await local.fetchUserData() {
            var user = cachedUser.toUserSettingsDomain()
            
            return user
        }
        do{
            let remoteUser =  try await remote.getUserData()
            let cachedUser = try await local.saveUserData(user: remoteUser)
            var user =  cachedUser.toUserSettingsDomain()
            
            return user
        }
        catch{
            print("Error in getting saved userin core data  \(error)")
            throw error
        }
    }
    
    func refreshUserData() async throws   {
            do {
                let remoteUser = try await remote.getUserData()
                let cachedUser = try await local.saveUserData(user: remoteUser)
                var user = cachedUser.toUserSettingsDomain()
           
               
            } catch {
                print("Error in refreshing user data: \(error)")
                throw error
            }
        }
    
    func getUserSubscription() async -> PlanType {
        do{
            let cachedUser = try await local.fetchUserData()
            print("The user Plan \(cachedUser?.subscriptionTier?.capitalized )")
            return PlanType(rawValue: cachedUser?.subscriptionTier?.capitalized ?? "Free") ?? .free
        }catch{
            print("Error")
            return .free
        }
    }
    
    func logout() async throws{
        do{
            try await remote.logoutUser()
            try authToken.clear()
            try await local.deleteUserData()
            
        }catch{
            print("error in the repor for the logout \(error)")
            throw error
        }
    }
    
    func getSubscription() async throws -> [SubscriptionPlan] {
        do{
           let response = try await remote.getSubscription()
            return     [
                SubscriptionPlan(type: .free, price: "0", label: "Free Plan",
                     features: ["3 sessions / month", "Basic score report", "Standard feedback"]),
                SubscriptionPlan(type: .plus, price: "\(response.PLUS)" , label: "Plus Plan",
                     features: ["12 sessions / month", "Detailed radar chart", "Priority AI feedback", "Coaching tips library"]),
                SubscriptionPlan(type: .pro, price: "\(response.PRO)", label: "Pro Plan",
                     features: ["Unlimited sessions", "Instant feedback", "All tracks unlocked", "1:1 coaching session"])
            ]
            
        }catch{
            print("error in the repor for the logout \(error)")
            throw error
        }
        
 
        
    }
    
    func getCoins() -> [CoinPack] {
        return   [
            CoinPack(coinsValue: "100", price: "29", subTitle: "Great for trying premium features"),
            CoinPack(coinsValue: "500", price: "119", subTitle: "Best value for regular practitioners"),
            CoinPack(coinsValue: "1000", price: "199", subTitle: "Power users & intensive prep")
        ]
    }
   
    
}
