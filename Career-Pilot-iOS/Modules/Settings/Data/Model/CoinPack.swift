//
//  CoinPack.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
struct CoinPack : Decodable {
    let coinsValue: String
    let price: String
    let subTitle: String
}
extension CoinPack {
    func toViewData() -> CoinsPackViewData {
        return CoinsPackViewData(
            coinsValue: self.coinsValue,
            price: self.price,
            subTitle: self.subTitle
        )
    }
}
