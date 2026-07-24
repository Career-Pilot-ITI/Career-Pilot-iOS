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
        "https://ed39-102-188-31-161.ngrok-free.app/"
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
        ["Content-Type": "application/json" ,
         "Authorization" :"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlcyI6WyJST0xFX1VTRVIiXSwiaWQiOjEsImVtYWlsIjoiRXlhZHc4N0BnbWFpbC5jb20iLCJzdWIiOiJFeWFkdzg3IiwiaWF0IjoxNzg0OTI1OTAyLCJleHAiOjE3ODQ5Mjk1MDJ9.5uPX8y6Wh9cs5gjmB_ZXWCe7wqnBSJ8CCE3sFrWl6_Q"]
    }
    

    
    
    
    
}
