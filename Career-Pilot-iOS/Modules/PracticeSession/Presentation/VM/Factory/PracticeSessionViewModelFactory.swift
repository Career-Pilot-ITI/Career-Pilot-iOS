//
//  PracticeSessionViewModelFactory.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation


enum PracticeSessionViewModelFactory {

    @MainActor static func makeStub(realRepo: Bool) -> PracticeSessionViewModel {
        
        let repository: InterviewRepository
        
        if realRepo{
            repository = DIContainer.shared.container.resolve(InterviewRepository.self)!
        }else{
            repository = StubInterviewRepository()
        }
        let validationService = InterviewValidationService()
        let speechRecognitionService = SpeechRecognitionService()
        let progressService = InterviewProgressService()

        let configuration = InterviewConfiguration(
            maxQuestions: 3,
            maxAnswerDuration: 240,   // 4 minutes per answer
            maxInterviewDuration: 120, // 30 minutes total
            silenceTimeout: 5 // 5s of silence before auto-submit
        )

        return PracticeSessionViewModel(
            startUseCase: StartInterviewUseCase(repository: repository, userLDS: UserLocalDataSourceImpl(coreData: CoreDataManager())),
            submitUseCase: SubmitAnswerUseCase(repository: repository, userDataRepository: UserDataRepoImp(remoteDataSource: UserDataRemoteDataSourceImp(networkService: URLSessionNetworkService()), localDataSource: UserLocalDataSourceImpl(coreData: CoreDataManager())), validationService: validationService, speechRecognitionService: speechRecognitionService),
            resumeUseCase: ResumeInterviewUseCase(repository: repository),
            finishUseCase: FinishInterviewUseCase(repository: repository),
            cancelUseCase: CancelInterviewUseCase(repository: repository),
            validationService: validationService,
            progressService: progressService,
            recordingService: AudioRecordingService(),
            silenceService: SilenceDetectionService(),
            speechService: SpeechPlaybackService()
        )
    }
}
