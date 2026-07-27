//
//  GetCoins.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class GetCoinsPlans {
    var settingsRepo : SettingsRepo
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    func execute() -> [CoinPack]{
        settingsRepo.getCoins()
    }

}
