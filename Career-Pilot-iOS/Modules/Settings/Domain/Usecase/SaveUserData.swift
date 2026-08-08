//
//  SaveUserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 07/08/2026.
//

import Foundation
class SaveUserDataUsecase{
    var repo : SettingsRepo
    init(repo : SettingsRepo) {
        self.repo = repo
    }
    func execute(user : UserSettingsDomain) async {
        do{
            try await
             repo.saveUserData(user: user.toDTO() )
        } catch{
            print("the error in saving local \(error)")
        }
    }
}
