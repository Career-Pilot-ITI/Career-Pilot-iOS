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
    func getUserData() async throws -> UserDTO {
        let endpoint = SettingsEndpoint.getUserData
        do{
            return try await apiService.request(endpoint)
        }  catch {
            print("Actual error: \(error)")
            throw error
        }
    }
    func getSubscription()  async{
        print("Here is the subscription")
    }
    func getCoins() async {
        print("Here is the coin")
    }
}
