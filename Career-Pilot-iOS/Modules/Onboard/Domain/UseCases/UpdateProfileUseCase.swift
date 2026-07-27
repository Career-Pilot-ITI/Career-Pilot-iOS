//
//  UpdateProfileUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

import Foundation




final class UpdateProfileUseCase: UseCase {
    
    typealias Input = User
    typealias Output = User
    
    var onBordingRepo: OnBordingRepo
    
    init(onBordingRepo: OnBordingRepo) {
        self.onBordingRepo = onBordingRepo
    }
    
    func execute(_ input: User) async throws -> User {
        guard InputValidator.isValidEmail(input.profile.email) else {
            throw UseCaseError.invalidEmail
        }
        return try await onBordingRepo.updateProfile(user: input)
    }
}
