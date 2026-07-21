//
//  PracticeSessionViewModelFactory.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation


enum PracticeSessionViewModelFactory {

    @MainActor static func makeStub() -> PracticeSessionViewModel {
        let repository = StubInterviewRepository()
        let validationService = InterviewValidationService()
        let speechRecognitionService = SpeechRecognitionService()
        let progressService = InterviewProgressService()

        let configuration = InterviewConfiguration(
            maxQuestions: 3,
            maxAnswerDuration: 240,   // 4 minutes per answer
            maxInterviewDuration: 1800, // 30 minutes total
            silenceTimeout: 5 , // 5s of silence before auto-submit
            trackID: 1
        )

        return PracticeSessionViewModel(
            configuration: configuration,
            startUseCase: StartInterviewUseCase(repository: repository),
            submitUseCase: SubmitAnswerUseCase(repository: repository, validationService: validationService, speechRecognitionService: speechRecognitionService),
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
