//
//  DIContainer+ViewModels.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

@MainActor
extension DIContainer{
    func registerViewModels(){
        
        //authViewModel
        container.register(AuthViewModel.self) { r in
            AuthViewModel(
                sendUseCase: r.resolve(SendOTPUseCase.self)!,
                verifyUseCase: r.resolve(VerifyOTPUseCase.self)!,
                toastManager: .shared
            )
        }
        //OnBordingViewModel
        container.register(OnBordingViewModel.self){ r in
            OnBordingViewModel(
                appState: r.resolve(AppState.self)!,
                uploadCvUseCase: r.resolve(UploadCvUseCase.self)!,
                getAllTracksUseCase: r.resolve(GetAllTrackesUseCase.self)!,
                updateProfileUseCase: r.resolve(UpdateProfileUseCase.self)!,
                saveUserUseCase: r.resolve(SaveUserUseCase.self)!
            )
        }
        
        // homeViewModel
        container.register(HomeViewModel.self){ r in
            HomeViewModel(
                userSession: r.resolve(UserSession.self)!,
                getAllTracksUseCase: r.resolve(GetAllTrackesUseCase.self)!,
                getAllSessionUseCase: r.resolve(LoadSessionsUseCase.self)!
                
            )
        }
        // RecommendedInterviewViewModel
        container.register(InterviewsViewModel.self){ r in
            InterviewsViewModel(
                getAllTracksUseCase: r.resolve(GetAllTrackesUseCase.self)!
            )
        }
        
        container.register(InterviewPrepViewModel.self) { resolver in
            InterviewPrepViewModel(
                permissionManager: resolver.resolve(
                    PermissionManaging.self
                )!,
                subscriptionAccessManaging: resolver.resolve((any SubscriptionAccessManaging).self)!
            )
        }
//        // MARK: - PracticeSession
//        container.register(PracticeSessionViewModel.self) { resolver in
//            
//            let userLocalDataSource: UserLocalDataSource = resolver.resolve(UserLocalDataSource.self)!
//            let user: User? = userLocalDataSource.getUser()
//            
//            guard let user = user else{
//                return
//            }
//            let trackId = user?.profile.trackId
//            
//            PracticeSessionViewModel(
//                configuration: InterviewConfiguration(
//                    maxQuestions: 8,
//                    maxAnswerDuration: 240,
//                    maxInterviewDuration: 1800,
//                    silenceTimeout: 5,
//                    trackID: trackId
//                ),
//                startUseCase: resolver.resolve(StartInterviewUseCaseProtocol.self)!,
//                submitUseCase: resolver.resolve(SubmitAnswerUseCaseProtocol.self)!,
//                resumeUseCase: resolver.resolve(ResumeInterviewUseCaseProtocol.self)!,
//                finishUseCase: resolver.resolve(FinishInterviewUseCaseProtocol.self)!,
//                cancelUseCase: resolver.resolve(CancelInterviewUseCaseProtocol.self)!,
//                validationService: resolver.resolve(InterviewValidationServicing.self)!,
//                progressService: resolver.resolve(InterviewProgressServicing.self)!,
//                recordingService: resolver.resolve(AudioRecordingServicing.self)!,
//                silenceService: resolver.resolve(SilenceDetectionServicing.self)!,
//                speechService: resolver.resolve(SpeechPlaybackServicing.self)!
//            )
//        }
        // MARK: - PracticeSession
        container.register(PracticeSessionViewModel.self) { resolver in

            return PracticeSessionViewModel(
                startUseCase: resolver.resolve(StartInterviewUseCaseProtocol.self)!,
                submitUseCase: resolver.resolve(SubmitAnswerUseCaseProtocol.self)!,
                resumeUseCase: resolver.resolve(ResumeInterviewUseCaseProtocol.self)!,
                finishUseCase: resolver.resolve(FinishInterviewUseCaseProtocol.self)!,
                cancelUseCase: resolver.resolve(CancelInterviewUseCaseProtocol.self)!,
                validationService: resolver.resolve(InterviewValidationServicing.self)!,
                progressService: resolver.resolve(InterviewProgressServicing.self)!,
                recordingService: resolver.resolve(AudioRecordingServicing.self)!,
                silenceService: resolver.resolve(SilenceDetectionServicing.self)!,
                speechService: resolver.resolve(SpeechPlaybackServicing.self)!, speechRecognitionService: resolver.resolve(SpeechRecognitionServicing.self)!
            )
        }
        
        container.register(ReportsListViewModel.self) { r in
            ReportsListViewModel(
                loadSessionsUseCase: r.resolve(LoadSessionsUseCase.self)!,
                deleteSessionUseCase: r.resolve(DeleteSessionUseCase.self)!
            )
        }

        container.register(SessionDetailViewModel.self) { (r, sessionId: Int) in
            SessionDetailViewModel(
                sessionId: sessionId,
                loadFeedbackUseCase: r.resolve(LoadSessionFeedbackUseCase.self)!
            )
        }
        
        // MARK: - Subscription, Payment, Settings ViewModels
        container.register(SubscriptionViewModel.self) { r in
            SubscriptionViewModel(
                getPlansUseCase: r.resolve(GetSubscribtionPlan.self)!,
                getUserSubscribtion: r.resolve(GetUserSubscribtion.self)!,  cancelUserSubscribtion: r.resolve(CancelSubscription.self)!, userSession: r.resolve(UserSession.self)!
            )
        }

        container.register(PaymentViewModel.self) { r in
            PaymentViewModel(
                verifyPaymentUseCase: r.resolve(VerifyPaymentUseCaseImp.self)!,
                checkoutUsecase: r.resolve(CheckoutUsecase.self)!,
                userSession: r.resolve(UserSession.self)!
            )
        }

        container.register(SettingsViewModel.self) { r in
            SettingsViewModel(
                userSession: r.resolve(UserSession.self)!,
                logout: r.resolve(LogoutUsecase.self)!
            )
        }
        container.register(ProfileViewModel.self){ r in 
            ProfileViewModel(updateUserDataUseCase:UpdateUserData(repo: r.resolve(SettingsRepoImp.self)!) , getTracks:r.resolve(GetAllTrackesUseCase.self)! , uploadCvUseCase:r.resolve(UploadCvUseCase.self)! , saveUsercase:r.resolve(SaveUserDataUsecase.self)! , userSession:r.resolve(UserSession.self)! 
           )
        }

        // MARK: - ATS ViewModel
        container.register(ATSViewModel.self) { r in
            ATSViewModel(
                getJobUseCase: r.resolve(GetJobByURLUseCase.self)!,
                scoreJobUseCase: r.resolve(ScoreCVAgainstJobUseCase.self)!,
                generateCoverLetterUseCase: r.resolve(GenerateCoverLetterUseCase.self)!,
                uploadCvUseCase: r.resolve(UploadCvUseCase.self)!,
                userRepo: r.resolve(UserDataRepo.self)!,
                userSession: r.resolve(UserSession.self)!,
                toastManager: .shared
            )
        }.inObjectScope(.container)

        // MARK: - CV Optimize ViewModel
        container.register(CvOptimizeViewModel.self) { r in
            CvOptimizeViewModel(
                triggerUseCase: r.resolve(TriggerCvOptimizeUseCase.self)!,
                pollUseCase: r.resolve(PollCvOptimizeUseCase.self)!
            )
        }.inObjectScope(.container)

    }
} 
//, updateUserDataUseCase: r.resolve(UpdateUserData.self)!
