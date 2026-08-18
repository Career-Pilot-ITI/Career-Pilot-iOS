//
//  RefreshUserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 26/07/2026.
//

import Foundation

class RefreshUserDataUseCase {
    private let settingsRepo: SettingsRepo
    
    init(settingsRepo: SettingsRepo) {
        self.settingsRepo = settingsRepo
    }
    
    func execute() async throws -> UserSettingsDomain {
        do {
            return try await settingsRepo.refreshUserData()
        } catch let networkError as NetworkError {
          
            print("Refresh user data failed with network error: \(networkError.userMessage)")
            throw networkError
        } catch {
            print("Refresh user data failed with unknown error: \(error)")
            throw NetworkError.unknown(error)
        }
    }
}
