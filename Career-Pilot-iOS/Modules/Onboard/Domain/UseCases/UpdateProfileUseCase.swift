//
//  UpdateProfileUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
//

struct UpdateProfileRequest {
    let profile: UserProfile
}

protocol UpdateProfileUseCaseProtocol: UseCase where Input == UpdateProfileRequest, Output == Void {}

final class UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    private let onBordingRepo: OnBordingRepo
    
    init(onBordingRepo: OnBordingRepo) {
        self.onBordingRepo = onBordingRepo
    }
    
    func execute(_ input: UpdateProfileRequest) async throws {
        try await onBordingRepo.updateProfile(profile: input.profile)
    }
}
