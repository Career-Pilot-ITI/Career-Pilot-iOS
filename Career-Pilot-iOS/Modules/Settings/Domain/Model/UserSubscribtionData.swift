//
//  UserSubscribtionData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/08/2026.
//

import Foundation
struct UserSubscribtionDomain {
    let tier: PlanType
    let isActive: Bool
    let startedAt: String
    let renewalDate: String?
    var cancelledAt: String?
    let pendingTier: String?
}

// MARK: - Domain to DTO
extension UserSubscribtionDomain {
    /// Maps your domain model back to a network DTO
    func toDTO() -> SubscriptionDTO {
        SubscriptionDTO(
            tier: tier.rawValue.uppercased(),
            isActive: isActive,
            startedAt: startedAt,
            renewalDate: renewalDate,
            cancelledAt: cancelledAt,
            pendingTier: pendingTier
        )
    }
}


