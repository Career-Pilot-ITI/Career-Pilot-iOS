//
//  DIContainer+UseCases.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

extension DIContainer{
    func registerUseCases(){
        
        container.register(SendOTPUseCase.self) { r in
            SendOTPUseCase(repository: r.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(VerifyOTPUseCase.self) { r in
            VerifyOTPUseCase(repository: r.resolve(AuthRepositoryProtocol.self)!)
        }
        //MARK: OnBording
        
        //1) UploadCvUseCase
        container.register(UploadCvUseCase.self){r in
            UploadCvUseCase(userDataRepo: r.resolve(UserDataRepo.self)!)
        }
        //2) GetAllTrackesUseCase
        container.register(GetAllTrackesUseCase.self) {r in
            GetAllTrackesUseCase(onBordingRepo: r.resolve(OnBordingRepo.self)!)
        }
        
        //3) UpdateProfileUseCase
        container.register(UpdateProfileUseCase.self) { r in
            UpdateProfileUseCase(onBordingRepo: r.resolve(OnBordingRepo.self)!)
        }
        
        container.register(SaveUserUseCase.self) { r in
            SaveUserUseCase(
                userRepository: r.resolve(UserDataRepo.self)!
            )
        }

        
        // MARK: - PracticeSession
        container.register(StartInterviewUseCaseProtocol.self) { resolver in
            StartInterviewUseCase(
                repository: resolver.resolve(InterviewRepository.self)!
            )
        }

        container.register(SubmitAnswerUseCaseProtocol.self) { resolver in
            SubmitAnswerUseCase(
                repository: resolver.resolve(InterviewRepository.self)!,
                validationService: resolver.resolve(InterviewValidationServicing.self)!
            )
        }

        container.register(ResumeInterviewUseCaseProtocol.self) { resolver in
            ResumeInterviewUseCase(
                repository: resolver.resolve(InterviewRepository.self)!
            )
        }

        container.register(FinishInterviewUseCaseProtocol.self) { resolver in
            FinishInterviewUseCase(
                repository: resolver.resolve(InterviewRepository.self)!
            )
        }

        container.register(CancelInterviewUseCaseProtocol.self) { resolver in
            CancelInterviewUseCase(
                repository: resolver.resolve(InterviewRepository.self)!
            )
        }
    }
}
