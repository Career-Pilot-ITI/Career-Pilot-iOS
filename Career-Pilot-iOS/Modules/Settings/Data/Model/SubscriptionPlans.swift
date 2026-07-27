//
//  SubscriptionPlans.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
struct SubscriptionPlan: Identifiable, Equatable {
    var id: PlanType { type }
    let type: PlanType
    let price: String
    let label: String
    let features: [String]
}
