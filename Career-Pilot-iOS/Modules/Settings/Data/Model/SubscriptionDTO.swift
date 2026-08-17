//
//  CurrentUserSubscibtion.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 15/08/2026.
//

import Foundation

struct SubscriptionDTO: Decodable {
    let tier: String
    let isActive: Bool
    let startedAt: String
    let renewalDate: String?
    let cancelledAt: String?
    let pendingTier: String?
}
extension SubscriptionDTO {
    /// Maps the network DTO to your domain model
    func toDomain() -> UserSubscribtionDomain {
        UserSubscribtionDomain(
            tier: PlanType(rawValue: tier.lowercased().capitalized) ?? .free,
            isActive: isActive,
            startedAt: startedAt,
            renewalDate: renewalDate,
            cancelledAt: cancelledAt,
            pendingTier: pendingTier
        )
    }
}


