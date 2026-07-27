//
//  CheckOutDomainModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation

enum CheckoutItem: Hashable {
    case subscription(planType: PlanType )
    case coinPack(packNumber: Int)  
}
