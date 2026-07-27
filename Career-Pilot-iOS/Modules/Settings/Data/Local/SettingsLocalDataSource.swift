//
//  SettingsLocalDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation
protocol SettingsLocalDataSource {
    func fetchUserData()async throws->UserProfileEntity?
    func updateUserData( userProfileEntity: UserProfileEntity) async throws
    func deleteUserData() async throws
    func saveUserData(user: UserSettingsDTO)async throws -> UserProfileEntity
    
}
