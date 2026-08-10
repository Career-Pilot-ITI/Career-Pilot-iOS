//
//  UpdateUserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 29/07/2026.
//

import Foundation
import UIKit
class UpdateUserData {
    var repo: SettingsRepo
    
    init(repo: SettingsRepo) {
        self.repo = repo
    }
    
    func execute(imagUrl: Data?, updateUserProfile: UserSettingsDomain) async throws {
        var mutableUser = updateUserProfile
        
        do {
        
            if let imagUrl = imagUrl {
                print("The image url is \(imagUrl)")
                do {
                    let response = try await repo.updateUserProfileAvatar(
                        avatarUploadRequestDTO: AvatarUploadDTO(
                            imageData: imagUrl,
                            fileType: "avatars",
                            boundry: "Boundary-\(UUID().uuidString)"
                        )
                    )
                    
                    mutableUser.avatarURL = URL(string: response.url)
                } catch {
                    print("the error \(error)")
                }
            }
            try await repo.updateUserProfile(updateProfileRequestDTO: mutableUser.toUpdateProfileRequestDTO())
        } catch {
            print("the error is \(error)")
            throw error
        }
    }
}
