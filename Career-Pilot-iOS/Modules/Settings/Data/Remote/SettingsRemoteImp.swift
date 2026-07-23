//
//  SettingsRemoteImp.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class SettingsRemoteImp : SettingsRemote{

    
    var apiService: NetworkService
    
    init(apiService: NetworkService) {
        self.apiService = apiService
    }
    
    func upgradeSubscription(upgradeSubscription: SubscriptionUpgrading) async throws -> PaymentResponse {
        let endPoint = SettingsEndpoint.upgradeSubscription(subscriptionUpgrading: upgradeSubscription)
        do {
            return try await apiService.request(endPoint)
        } catch {
            print("Actual error: \(error)")
            throw error
        } }
    
    func logoutUser()  async throws{
        let endpoint = SettingsEndpoint.logout
        do{
            return try await apiService.request(endpoint)
        }catch{
            print("Logout error : \(error)")
           throw error
        }
    }
    func getUserData() async -> User {
        print("user here it is ")
        return User(id: 1, phoneNumber: "01554132837", profile: UserProfile(displayName: "Eyad waleed", username: "eyad", email: "eyadw@gmail.com", avatarUrl: URL(string: ""), avatarFileId: 5, cvFileId: 10, gender: "", dateOfBirth: Date.now, targetRole: "", industry: "", experienceLevel: "", currentJobTitle: "", yearsOfExperience: 4, cvUrl: URL(string: ""), skills: [""], targetCompanies: [], educationLevel: "", timezone: "", termsAccepted: true, subscriptionTier: "", coinBalance: 500, onboardingCompleted: true, trackName: "Software engineeering", trackId: 5), isNewUser: true)
    }
    func getSubscription()  async{
        print("Here is the subscription")
    }
    func getCoins() async {
        print("Here is the coin")
    }
}
