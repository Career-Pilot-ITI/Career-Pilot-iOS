//
//  RefreshUserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 26/07/2026.
//

import Foundation
class RefreshUserDataUseCase {
    var settingsRepo : SettingsRepo
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    func execute() async {
        
        do {
            try await settingsRepo.refreshUserData()
        }
        catch{
            print("Shows error refresh \(error)")
        }
       
    }

}
