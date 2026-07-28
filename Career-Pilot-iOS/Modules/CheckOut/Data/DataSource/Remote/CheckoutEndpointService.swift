//
//  CheckoutEndpointService.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
enum CheckoutEndpointService : APIEndpoint{
    case upgradeUserSubscriptionPlan(subscriptionUpgrading:SubscriptionUpgrading)
    case buyingCoins(coinRequest : CointRequestedDTo)
    case getUserCoins
    case getUserSubscription
    
    var path: String {
        switch self {
        case .upgradeUserSubscriptionPlan:
            return "/api/v1/subscriptions/upgrade"
        case .buyingCoins:
            return  "/api/v1/wallet/top-up"
        case .getUserCoins :
            return "/api/v1/wallet/balance"
        case .getUserSubscription:
            return "/api/v1/subscriptions/current"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case.upgradeUserSubscriptionPlan:
            return .post
        case .buyingCoins:
            return .post
        case .getUserCoins:
            return .get
        case .getUserSubscription:
            return .get
        }
    }
    
    var requiresAuthentication: Bool {
        switch self {
        case .upgradeUserSubscriptionPlan , .buyingCoins , .getUserCoins , .getUserSubscription:
            return true
      
            
        }
    }
    var body: Data? {
        switch self {
        case .upgradeUserSubscriptionPlan(let subscriptionUpgrading):
            return Self.encode(subscriptionUpgrading)
        case .buyingCoins(let coinRequeset) :
            return Self.encode(coinRequeset)
            
        case .getUserCoins , .getUserSubscription:
            return nil
        }
    }
    
    var headers: [String : String]  {
        let tokenString: String
        do {
            
            if let tokens = try KeychainAuthTokenStore().loadTokens() {
                tokenString = tokens.accessToken
            } else {
                tokenString = ""
            }
        } catch {
            tokenString = ""
        }
        return ["Content-Type": "application/json" ,
         "Authorization": "Bearer \(tokenString)"
]}
}
