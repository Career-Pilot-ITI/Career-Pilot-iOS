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
        print("I've  enter in the fetching phase ")
        if let cachedUser = try await local.fetchUserData() {
            var user = cachedUser.toUserSettingsDomain()
            
            // 1. Safely unwrap and clean the avatar URL string
            if let rawAvatarURL = cachedUser.profile?.avatarURL {
                var cleanedPath = rawAvatarURL.replacingOccurrences(of: "\\", with: "")
                if(cleanedPath.first == "/" && SettingsEndpoint.getUserData.baseURL.last == "/"){
                    cleanedPath.removeFirst()
                }
                let fullURLString = "\(SettingsEndpoint.getUserData.baseURL)\(cleanedPath)"
                
                print("getting the avatar \(fullURLString)")
                
                // 2. Pass the final string (or a valid URL) to your download method
                if let avatarData = try? await downloadAvatarData(from: fullURLString) {
                    user.avatar = avatarData
                }
            }
            guard let avatarUser = user.avatar else {
                print("The user avatar is null please look at u code")
                throw NSError(domain: "UserDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User avatar is missing"])
            }
            print("The user avatar that downloaded is \(avatarUser)")
                  
                    return user
        }




        do {
            print("The user  is not saved in the core data going to remote  ")

            let remoteUser = try await remote.getUserData()
            let cachedUser = try await local.saveUserData(user: remoteUser)
            var user = cachedUser.toUserSettingsDomain()
            if let rawAvatarURL = cachedUser.profile?.avatarURL {
                let cleanedPath = rawAvatarURL.replacingOccurrences(of: "\\", with: "")
                let fullURLString = "\(SettingsEndpoint.getUserData.baseURL)\(cleanedPath)"
                
                print("getting the avatar \(fullURLString)")
                
                // 2. Pass the final string (or a valid URL) to your download method
                if let avatarData = try? await downloadAvatarData(from: fullURLString) {
                    user.avatar = avatarData
                }
            }
            guard let avatarUser = user.avatar else {
                print("The user avatar is null please look at u code")
                throw NSError(domain: "UserDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User avatar is missing"])
            }
            print("The user avatar that downloaded is \(avatarUser)")

            
            return user
        } catch {
            print("Error in getting saved user in core data \(error)")
            throw error
        }
    }

    private func downloadAvatarData(from urlString: String?) async throws -> Data? {
        guard let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) else {
            return nil
        }
        
        let data = try await ImageLoader.loadImage(from: URL(string :urlString)!)
        return data
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
          
            return PlanType(rawValue: cachedUser?.profile?.subscriptionTier?.capitalized ?? "Free") ?? .free
        }catch{
            print("Error")
            return .free
        }
    }
    
    func logout() async throws{
        do{
            try await remote.logoutUser()
            try await local.deleteUserData()
            try authToken.clear()
            
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
    func updateUserProfile(updateProfileRequestDTO: UpdateProfileRequestDTO) async throws {
        do{
            var response = try await remote.updateUserProfile(updateProfileRequestDTO: updateProfileRequestDTO)
            try await  local.updateUserData(user:response)
            print("The image do not have any error ")

        }catch{
            print("the error is \(error)")
            throw error
        }
    }
    func updateUserProfileAvatar(avatarUploadRequestDTO: AvatarUploadDTO) async throws -> AvatarResponseDTO {
        do{
            print("The image do not have any error ")

            return try await remote.updateUserProfileAvatar(avatarUploadRequestDTO: avatarUploadRequestDTO)
            
        }catch{
            print("User error \(error)")
             throw error
        }
    }
   
    func saveUserData(user: UserSettingsDTO) async throws {
        try await local.saveUserData(user: user)
    }
}
