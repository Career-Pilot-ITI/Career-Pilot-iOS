//
//  Logout.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class LogoutUsecase{
    var settingsRepo : SettingsRepo
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    func execute() async throws{
        do{
            try await settingsRepo.logout()

        }
        catch {
            throw error
        }
    }
}
