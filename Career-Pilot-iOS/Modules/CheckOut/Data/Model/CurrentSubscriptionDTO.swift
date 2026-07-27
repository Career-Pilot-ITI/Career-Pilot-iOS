//
//  CurrentSubscriptionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 26/07/2026.
//

import Foundation

struct CurrentSubscriptionDTO:Decodable {
    let tier: String
    let isActive: Bool
    let startedAt: Date
    let renewalDate: Date
    let cancelledAt: Date?
    let pendingTier: String?

}
extension CurrentSubscriptionDTO {
    
    func toDomain() -> CurrentSubscriptionDomain {
        
        let capitalizedTier = tier.capitalized
        let planTier = PlanType(rawValue: capitalizedTier) ?? .free
        
        let mappedPendingTier = pendingTier?.capitalized.flatMap { PlanType(rawValue: String($0)) }
        
        return CurrentSubscriptionDomain(
            tier: planTier,
            isActive: isActive
         )
    }
}
