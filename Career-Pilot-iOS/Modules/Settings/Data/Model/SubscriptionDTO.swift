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
        print("the user is having plan \(tier.lowercased().capitalized)")
        print("the user subscribtion tier is \(PlanType(rawValue: tier.lowercased().capitalized))")
        return UserSubscribtionDomain(
            tier: PlanType(rawValue: tier.lowercased()) ?? .free,
            isActive: isActive,
            startedAt: startedAt,
            renewalDate: renewalDate,
            cancelledAt: cancelledAt,
            pendingTier: pendingTier
        )
    }
}


