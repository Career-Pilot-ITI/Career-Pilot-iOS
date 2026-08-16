//
//  SubscribtionPlan.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/08/2026.
//

import Foundation
import Combine

// MARK: - App Features
enum AppFeature {
    case ats
    case quiz
    case videoSession
    case normalSession
}

// MARK: - Access Manager Protocol
@MainActor
protocol SubscriptionAccessManaging: ObservableObject {
    func canAccess(_ feature: AppFeature) -> Bool
    func requiredPlan(for feature: AppFeature) -> PlanType
}

@MainActor
final class SubscriptionAccessManager: SubscriptionAccessManaging {
    @Published private(set) var currentPlan: PlanType = .free
    
    private let userSession: UserSession
    private var cancellables = Set<AnyCancellable>()
    
    init(userSession: UserSession) {
        self.userSession = userSession
        
        // Listen to changes published by userSession
        userSession.$userData
            .receive(on: RunLoop.main)
            .sink { [weak self] userData in
                self?.updateCurrentPlan(from: userData)
            }
            .store(in: &cancellables)
    }
    
    private func updateCurrentPlan(from userData: UserModelSettingsView?) {
        guard let tierString = userData?.toUserSettingsDomain().subscriptionTier else {
            self.currentPlan = .free
            return
        }
        self.currentPlan = PlanType(rawValue: tierString) ?? .free
    }
    
    func canAccess(_ feature: AppFeature) -> Bool {
        switch feature {
        case .normalSession:
            return true // Available to all plans
            
        case .quiz, .ats:
            return currentPlan == .plus || currentPlan == .pro
            
        case .videoSession:
            return currentPlan == .pro
        }
    }
    
    func requiredPlan(for feature: AppFeature) -> PlanType {
        switch feature {
        case .videoSession:
            return .pro
        case .quiz, .ats:
            return .plus
        case .normalSession:
            return .free
        }
    }
}


