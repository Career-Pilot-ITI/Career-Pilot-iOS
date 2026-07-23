//
//  GetUserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import Foundation
class GetUserDataUseCase{
    var settingsRepo : SettingsRepo
    
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    func execute() async->User{
        return await settingsRepo.fetchUserData()
    }
    
}
