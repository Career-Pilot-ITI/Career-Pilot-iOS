//
//  UpdateProfileUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation




final class UpdateProfileUseCase: UseCase {
    typealias Input = OnBoardingUser
    typealias Output = User
    
    var onBordingRepo: OnBordingRepo
    var  settingsRepo : SettingsRepo
    init(onBordingRepo: OnBordingRepo , settingsRepo : SettingsRepo) {
        self.onBordingRepo = onBordingRepo
        self.settingsRepo = settingsRepo
    }
    
    func execute(_ input: OnBoardingUser) async throws -> User {
        try ProfileValidator.validateOnboard(input.toUser())
        var mutableUser = input
        if let imagUrl =  input.profileImageData {
            print("The image url is \(imagUrl)")
            do {
                let response = try await settingsRepo.updateUserProfileAvatar(
                    avatarUploadRequestDTO: AvatarUploadDTO(
                        imageData: imagUrl,
                        fileType: "avatars",
                        boundry: "Boundary-\(UUID().uuidString)"
                    )
                )
                
                mutableUser.avatarUrl = response.url
            } catch {
                print("the error \(error)")
            }
        }

        return try await onBordingRepo.updateProfile(user: mutableUser.toUser())
    }
}
