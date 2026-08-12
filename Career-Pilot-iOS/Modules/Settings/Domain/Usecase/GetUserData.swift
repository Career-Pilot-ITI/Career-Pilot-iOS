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
    func execute() async throws -> UserModelSettingsView  {
        do{
            print("I excuted with not problem ")
                   let response = await  try settingsRepo.fetchUserData()
            print("the user avatar value in the useCase is \(response.avatar)")
            var userVeiw =  response.toUserModelSettingsView()
           return userVeiw
            
        }
        catch {
            print("The error in fetching user data is \(error)")
            throw error
        }
    }
}
