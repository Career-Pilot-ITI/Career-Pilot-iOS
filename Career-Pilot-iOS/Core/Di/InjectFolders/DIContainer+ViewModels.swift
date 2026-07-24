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
        
        // MARK: - PracticeSession
        container.register(PracticeSessionViewModel.self) { resolver in
            PracticeSessionViewModel(
                configuration: InterviewConfiguration(
                    maxQuestions: 8,
                    maxAnswerDuration: 240,
                    maxInterviewDuration: 1800,
                    silenceTimeout: 5,
                    trackID: 5555
                ),
                startUseCase: resolver.resolve(StartInterviewUseCaseProtocol.self)!,
                submitUseCase: resolver.resolve(SubmitAnswerUseCaseProtocol.self)!,
                resumeUseCase: resolver.resolve(ResumeInterviewUseCaseProtocol.self)!,
                finishUseCase: resolver.resolve(FinishInterviewUseCaseProtocol.self)!,
                cancelUseCase: resolver.resolve(CancelInterviewUseCaseProtocol.self)!,
                validationService: resolver.resolve(InterviewValidationServicing.self)!,
                progressService: resolver.resolve(InterviewProgressServicing.self)!,
                recordingService: resolver.resolve(AudioRecordingServicing.self)!,
                silenceService: resolver.resolve(SilenceDetectionServicing.self)!,
                speechService: resolver.resolve(SpeechPlaybackServicing.self)!
            )
        }
    }
}
