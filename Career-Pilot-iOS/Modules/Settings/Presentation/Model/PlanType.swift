//
//  Plan.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
import SwiftUI
enum PlanType: String, CaseIterable {
    case free = "free"
    case plus = "plus"
    case pro = "pro"
}
extension PlanType {
    var accentColor: Color {
        switch self {
        case .free: return .gray400
        case .plus: return .orange
        case .pro: return .teal
        }
    }
}

extension PlanType {
    var titleName: String {
        switch self {
        case .free: return "Free Plan"
        case .plus: return "Plus Plan"
        case .pro: return "Max Plan"
        }
    }
    
    var includedFeatures: [String] {
        switch self {
        case .pro:
            return [
                "Unlimited AI mock interview sessions",
                "Priority voice practice & coaching",
                "Advanced ATS CV scoring & optimization",
                "Full CV AI analysis & suggestions",
                "Full custom track interview practice",
                "Export session reports as PDF"
            ]
        case .plus:
            return [
                "AI mock interview sessions",
                "Unlimited voice practice mode",
                "ATS CV scoring & optimization",
                "CV AI analysis",
                "Quiz-based interview practice",
                "Export session reports as PDF"
            ]
        case .free:
            return [
                "3 AI mock interview sessions / month",
                "Standard voice practice mode",
                "Basic CV analysis report"
            ]
        }
    }
}


