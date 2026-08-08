//
//  AppRoute.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 15/07/2026.
//

import Foundation
import SwiftUI


enum AuthRoute: Hashable {
    case phoneEntryScreen
    case sendingOTPScreen(phoneNumber: String)
    case otpScreen(phoneNumber: String)
    case successOTPScreen
    
    // MARK : Onboarding
    case onboardingScreen(vm : OnBordingViewModel)
   
}

enum HomeRoute: Hashable {
    case sessionDetail(metrics: [RadarMetric], suggestions: [CoachingSuggestion])
    case practiceInterview(trackName: String, trackId: Int, interviewType: InterviewType)
    case interviewPrep(trackName: String, trackId: Int, interviewType: InterviewType)
}

enum   CheckoutDisplayInfo : Hashable {
    case subscription(plan: String, monthlyPrice: String, billingCycle: String, total: String, checkoutItem: CheckoutItem)
    case coinPack(name: String, pricePerPack: String, coinsIncluded: String, total: String, checkoutItem: CheckoutItem)
    
    var checkoutItem: CheckoutItem {
        switch self {
        case .subscription(_, _, _, _, let item): return item
        case .coinPack(_, _, _, _, let item): return item
        }
    }
}

enum SettingsRoute : Hashable {
    case checkout(item: CheckoutDisplayInfo)
    case subscribtion
    case coin
    case profile
}

enum ReportsRoute: Hashable {
//    case sessionDetail(metrics: [RadarMetric], suggestions: [CoachingSuggestion])
//    case sessionHistory(sessionCount: Int, sessionAvgScore: Double, sessions: [Session])
//    case questionBreakdown(questions: [QuestionReview])
    case sessionDetail(sessionId: Int)
    case questionBreakdown(sessionId: Int)
}

