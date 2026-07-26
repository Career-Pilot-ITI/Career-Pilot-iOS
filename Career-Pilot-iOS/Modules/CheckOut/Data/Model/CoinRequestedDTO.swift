//
//  CoinRequestedDTO.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 25/07/2026.
//

import Foundation
struct CointRequestedDTo : Decodable , Encodable {
    var amount : Int ; // 100 || 500 || 1000
    var currency : String  // e.g. "EGP"
    var method  : String // card or cash
}
