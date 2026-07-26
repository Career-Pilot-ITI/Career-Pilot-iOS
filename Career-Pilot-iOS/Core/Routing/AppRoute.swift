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
    case onboardingScreen(vm: OnBordingViewModel)
}

enum HomeRoute: Hashable {
    case sessionDetail(metrics: [RadarMetric], suggestions: [CoachingSuggestion])
}

enum ReportsRoute: Hashable {
//    case sessionDetail(metrics: [RadarMetric], suggestions: [CoachingSuggestion])
//    case sessionHistory(sessionCount: Int, sessionAvgScore: Double, sessions: [Session])
//    case questionBreakdown(questions: [QuestionReview])
    case sessionDetail(sessionId: Int)
    case questionBreakdown(sessionId: Int)
}

