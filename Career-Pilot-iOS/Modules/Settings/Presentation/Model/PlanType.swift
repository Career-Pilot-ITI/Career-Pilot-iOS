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
