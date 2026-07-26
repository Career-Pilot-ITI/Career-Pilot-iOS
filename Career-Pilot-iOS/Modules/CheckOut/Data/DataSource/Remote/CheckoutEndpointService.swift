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
    var path: String {
        switch self {
        case .upgradeUserSubscriptionPlan:
            return "api/v1/subscriptions/upgrade"
        case .buyingCoins:
            return  "api/v1/wallet/top-up"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case.upgradeUserSubscriptionPlan:
            return .post
        case .buyingCoins:
            return .post
        }
    }
    
    var requiresAuthentication: Bool {
        switch self {
        case .upgradeUserSubscriptionPlan , .buyingCoins:
            return true
      
        }
    }
    var body: Data? {
        switch self {
        case .upgradeUserSubscriptionPlan(let subscriptionUpgrading):
            return Self.encode(subscriptionUpgrading)
        case .buyingCoins(let coinRequeset) :
            return Self.encode(coinRequeset)
            
        }
    }
    
}
