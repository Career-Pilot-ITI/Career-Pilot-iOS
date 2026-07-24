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
            user.avatar =  await try cachedUser.avatarUrl == nil ? nil : ImageLoader.loadImage(from: URL(string:cachedUser.avatarUrl!)!)
            return user
        }
        do{
            let remoteUser =  try await remote.getUserData()
            let cachedUser = try await local.saveUserData(user: remoteUser)
            var user =  cachedUser.toUserSettingsDomain()
            user.avatar = await try cachedUser.avatarUrl == nil ? nil : ImageLoader.loadImage(from: URL(string:cachedUser.avatarUrl!)!)
            return user
        }
        catch{
            print("Error in getting saved userin core data  \(error)")
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
    
    func logout() async throws{
        do{
            try await authToken.save(AuthTokens(accessToken: "eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWQiOjEsImVtYWlsIjoiRXlhZHc4N0BnbWFpbC5jb20iLCJzdWIiOiJFeWFkdzg3IiwiaWF0IjoxNzg0OTI1OTAyLCJleHAiOjE3ODQ5Mjk1MDJ9.5uPX8y6Wh9cs5gjmB_ZXWCe7wqnBSJ8CCE3sFrWl6_Q", refreshToken: "f2bdf399-ea22-4d21-9fb4-ccd75c1854f2", expiresIn: 3600000))
        }
        catch{}
        do{
            try await remote.logoutUser()
            try authToken.clear()
            try await local.deleteUserData()
            
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
