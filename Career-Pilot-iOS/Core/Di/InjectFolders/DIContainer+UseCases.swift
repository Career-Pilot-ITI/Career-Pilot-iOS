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
        
        // get currentUser
        container.register(GetCurrentUserUseCaseProtocol.self) { resolver in
            GetCurrentUserUseCase(
                repository: resolver.resolve(UserDataRepo.self)!
            )
        }

        
        // MARK: - PracticeSession
        container.register(StartInterviewUseCaseProtocol.self) { resolver in
            StartInterviewUseCase(
                repository: resolver.resolve(InterviewRepository.self)!,
                userLDS: resolver.resolve(UserLocalDataSource.self)!
            )
        }

        container.register(SubmitAnswerUseCaseProtocol.self) { resolver in
            SubmitAnswerUseCase(
                repository: resolver.resolve(InterviewRepository.self)!, userDataRepository: resolver.resolve(UserDataRepo.self)!,
                validationService: resolver.resolve(InterviewValidationServicing.self)!, speechRecognitionService: resolver.resolve(SpeechRecognitionServicing.self)!
                
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
        
        container.register(LoadSessionsUseCase.self) { r in
            LoadSessionsUseCase(
                repository: r.resolve(ReportsRepositoryProtocol.self)!,
                currentUserProvider: r.resolve(CurrentUserProviding.self)!
            )
        }
        container.register(LoadSessionFeedbackUseCase.self) { r in
            LoadSessionFeedbackUseCase(repository: r.resolve(ReportsRepositoryProtocol.self)!)
        }
        container.register(DeleteSessionUseCase.self) { r in
            DeleteSessionUseCase(repository: r.resolve(ReportsRepositoryProtocol.self)!)
        }
        // MARK: - Settings & Subscription Use Cases
        container.register(GetSubscribtionPlan.self) { r in
            GetSubscribtionPlan(settingsRepo: r.resolve(SettingsRepoImp.self)!)
        }

        container.register(GetUserSubscribtion.self) { r in
            GetUserSubscribtion(settingsRepo: r.resolve(SettingsRepoImp.self)!)
        }

        container.register(GetUserDataUseCase.self) { r in
            GetUserDataUseCase(settingsRepo: r.resolve(SettingsRepoImp.self)!)
        }

        container.register(RefreshUserDataUseCase.self) { r in
            RefreshUserDataUseCase(settingsRepo: r.resolve(SettingsRepoImp.self)!)
        }

        container.register(LogoutUsecase.self) { r in
            LogoutUsecase(settingsRepo: r.resolve(SettingsRepoImp.self)!)
        }

        // MARK: - Payment & Checkout Use Cases
        container.register(CheckoutUsecase.self) { r in
            CheckoutUsecase(checkoutRepo: r.resolve(CheckoutRepoImplementation.self)!)
        }

        container.register(VerifyPaymentUseCaseImp.self) { r in
            VerifyPaymentUseCaseImp(
                getUserData: r.resolve(GetUserDataUseCase.self)!,
                checkoutRepo: r.resolve(CheckoutRepoImplementation.self)!
            )
        }
        container.register(SaveUserDataUsecase.self){
            r in
            SaveUserDataUsecase(repo: r.resolve(SettingsRepoImp.self)!)
        }

        // MARK: - ATS Use Cases
        container.register(GetJobByURLUseCase.self) { r in
            GetJobByURLUseCase(repository: r.resolve(ATSRepositoryProtocol.self)!)
        }

        container.register(ScoreCVAgainstJobUseCase.self) { r in
            ScoreCVAgainstJobUseCase(repository: r.resolve(ATSRepositoryProtocol.self)!)
        }

        container.register(GenerateCoverLetterUseCase.self) { r in
            GenerateCoverLetterUseCase(repository: r.resolve(ATSRepositoryProtocol.self)!)
        }

    }
    
}
