//
//  File.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
class CheckoutRemoteDataSourceImp : CheckoutRemoteDataSource
{
 
    
    var checkOutNetworkService : NetworkService
    init(checkOutNetworkService: NetworkService) {
        self.checkOutNetworkService = checkOutNetworkService
    }
    func getUserCoin() async throws -> UserWalletBalanceDTO {
        let endPoint = CheckoutEndpointService.getUserCoins
        do {
            return try await checkOutNetworkService.request(endPoint)
        } catch {
            print("Actual error: \(error)")
            throw error
        }
        
    }
    
    
    func getUserSubscription() async throws -> CurrentSubscriptionDTO {
        let endPoint = CheckoutEndpointService.getUserSubscription
        do {
            return try await checkOutNetworkService.request(endPoint)
        } catch {
            print("Actual error: \(error)")
            throw error
        }
    }
    func upgradeSubscription(upgradeSubscription: SubscriptionUpgrading) async throws -> PaymentResponse {
        let endPoint = CheckoutEndpointService.upgradeUserSubscriptionPlan(subscriptionUpgrading: upgradeSubscription)
        do {
            return try await checkOutNetworkService.request(endPoint)
        } catch {
            print("Actual error: \(error)")
            throw error
        } }
    
    func buyingCoins(coinRequest: CointRequestedDTo) async throws -> PaymentResponse {
        let endPoint = CheckoutEndpointService.buyingCoins(coinRequest: coinRequest)
        do {
            return try await checkOutNetworkService.request(endPoint)
        } catch {
            print("Actual error: \(error)")
            throw error
        } }
}
