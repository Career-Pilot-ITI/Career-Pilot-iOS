//
//  SettingsEndpoint.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
enum SettingsEndpoint : APIEndpoint{
    case logout
    case getUserData
    case upgradeSubscription(subscriptionUpgrading:SubscriptionUpgrading)
    
    var baseURL: String{
        "https://660c-102-188-23-75.ngrok-free.app/"
    }
    
    var path: String{
        switch self {
        case.getUserData:
            return "api/v1/profile"
        case.upgradeSubscription:
            return "api/v1/upgrade"
        case .logout:
            return "api/v1/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case.getUserData:
            return .get
        case.upgradeSubscription:
            return .post
        case .logout:
            return .post
        }
    }
    var body: Data? {
            switch self {
            case .logout, .getUserData:
                return nil
            case .upgradeSubscription(let subscriptionUpgrading):
                return Self.encode(subscriptionUpgrading)
            }
        }
    var requiresAuthentication: Bool {
            switch self {
            case .getUserData:  return true
            case .upgradeSubscription:  return true
            case .logout:  return true
            }
        }
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    

    
    
    
    
}
