//
//  SubscribtionPlan.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/08/2026.
//

import Foundation
// MARK: - App Features
enum AppFeature {
    case ats
    case quiz
    case videoSession
    case normalSession
}

// MARK: - Access Manager Protocol
protocol SubscriptionAccessManaging {
    func canAccess(_ feature: AppFeature) -> Bool
    func requiredPlan(for feature: AppFeature) -> PlanType
}
@MainActor

final class SubscriptionAccessManager: SubscriptionAccessManaging {
    private let userSession: UserSession
    
    init(userSession: UserSession) {
        self.userSession = userSession
    }
    
    private var currentPlan: PlanType {
        PlanType(rawValue: (userSession.userData?.toUserSettingsDomain().subscriptionTier)!) ?? .free
    }
    
    func canAccess(_ feature: AppFeature) -> Bool {
        switch feature {
        case .quiz, .ats , .normalSession:
            return currentPlan == .plus || currentPlan == .pro
            
        case .videoSession , .quiz, .ats , .normalSession :
            return currentPlan == .pro
            
        case .normalSession:
            return true
        }
    }
    
    func requiredPlan(for feature: AppFeature) -> PlanType {
        switch feature {
        case .quiz , .ats :
            return .pro
        case .videoSession , .normalSession,.quiz , .ats:
            return .plus
        default:
            return .free
        }
    }
}


