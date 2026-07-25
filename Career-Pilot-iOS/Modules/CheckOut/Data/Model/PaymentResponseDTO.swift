//
//  PaymentResponse.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
struct PaymentResponse : Decodable{
    var checkoutUrl : String
    var merchantOrderId : String
}
