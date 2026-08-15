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
    init(remote: SettingsRemote ,  local : SettingsLocalDataSource,authToken : AuthTokenStoring) {
        self.remote = remote
        self.local = local
        self.authToken = authToken
    }

    public func fetchUserData() async throws -> UserSettingsDomain {
        print("I've entered in the fetching phase")
        
        // 1. Try fetching from Local Storage
        if let cachedUser = try await local.fetchUserData() {
            var domainUser = cachedUser.toUserSettingsDomain()
            
            if let avatarData = await processAvatar(for: cachedUser.profile?.avatarURL) {
                domainUser.avatar = avatarData
                print("The user avatar that was downloaded is \(avatarData)")
            } else {
                print("The user avatar is null or failed to download")
            }
            
            return domainUser
        }

        // 2. Fallback to Remote API
        print("The user is not saved in Core Data; fetching from remote")
        return try await refreshUserData()
    }

    /// Forces a remote fetch from the API, updates Core Data, and returns the updated user data.
      func refreshUserData() async throws -> UserSettingsDomain {
        do {
            print("Fetching fresh user data from remote API")
            let remoteUser = try await remote.getUserData()
            let cachedUser = try await local.saveUserData(user: remoteUser)
            var domainUser = cachedUser.toUserSettingsDomain()
            
            print("The user avatar URL found = \(String(describing: domainUser.avatarURL))")
            
            if let avatarData = await processAvatar(for: cachedUser.profile?.avatarURL) {
                domainUser.avatar = avatarData
                print("The user avatar that was downloaded is \(avatarData)")
                return domainUser
            } else {
                print("The user avatar is null; throwing error")
                throw NSError(
                    domain: "UserDataError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "User avatar is missing or could not be downloaded"]
                )
            }
        } catch {
            print("Error refreshing user data: \(error)")
            throw error
        }
    }

    // MARK: - Private Helper Methods

    /// Cleans raw avatar URL path and downloads image data asynchronously.
    private func processAvatar(for rawAvatarURL: String?) async -> Data? {
        guard let rawAvatarURL = rawAvatarURL, !rawAvatarURL.isEmpty else {
            return nil
        }
        
        guard let fullURLString = buildFullAvatarURL(from: rawAvatarURL) else {
            return nil
        }
        
        print("Getting avatar from: \(fullURLString)")
        return try? await downloadAvatarData(from: fullURLString)
    }

    /// Constructs a well-formed URL string by cleaning escape characters and duplicate slashes.
    private func buildFullAvatarURL(from rawPath: String) -> String? {
        var cleanedPath = rawPath.replacingOccurrences(of: "\\", with: "")
        let baseURL = SettingsEndpoint.getUserData.baseURL
        
        if cleanedPath.hasPrefix("/") && baseURL.hasSuffix("/") {
            cleanedPath.removeFirst()
        }
        
        return "\(baseURL)\(cleanedPath)"
    }
    private func downloadAvatarData(from urlString: String?) async throws -> Data? {
        guard let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) else {
            return nil
        }
        
        let data = try await ImageLoader.loadImage(from: URL(string :urlString)!)
        return data
    }
    func getUserSubscription() async -> UserSubscribtionDomain {
        do{
            let subscribtionUser = try await remote.getUserSubscription()
            print("Subscribtion of the user : \(subscribtionUser)")
            return subscribtionUser.toDomain()
          
            
        }catch{
            print("Error")
            return UserSubscribtionDomain(tier: .free, isActive: true, startedAt: "", renewalDate: "", cancelledAt: "", pendingTier: "")
        }
    }
    func logout() async throws{
        do{
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
                     features: ["3 sessions / month for reocord intreview only", "No ATS", "No video interview"]),
                SubscriptionPlan(type: .plus, price: "\(response.PLUS)" , label: "Plus Plan",
                     features: ["Record sessions are open", "ATS is open", "Quiz sessions are open", "No video internview"]),
                SubscriptionPlan(type: .pro, price: "\(response.PRO)", label: "Pro Plan",
                     features: ["Record sessions are open", "ATS is open", "Quiz sessions are open", "Video interivew is opened"])
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

            return try await remote.updateUserProfileAvatar(avatarUploadRequestDTO: avatarUploadRequestDTO)
            
        }catch{
            print("User error \(error)")
             throw error
        }
    }
    func saveUserData(user: UserSettingsDTO) async throws {
        try await local.saveUserData(user: user)
    }
    func downgradeUserSubscription() async throws {
        try await remote.downgradeUserSubscribtion()
    }
}
