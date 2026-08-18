//
//  SubscriptionUpgrading.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
struct SubscriptionUpgrading : Encodable , Decodable {
    var tier : String ;  // "Free" | "Plus" | "Max"
    var currency : String  // e.g. "EGP"
    var method  : String // card or cash
}
