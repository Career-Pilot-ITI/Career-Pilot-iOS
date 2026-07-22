//
//  PracticeSessionViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation


enum PracticeSessionScreenState: Equatable {
    case loading
    case aiTurn
    case waitingForAnswer
    case recording(silenceWarning: SilenceWarning?)
    case submittingAnswer
    case reconnecting
    case completed
    case error(InterviewError)
}

struct SilenceWarning: Equatable {
    let remainingSeconds: Int
}

@MainActor
final class PracticeSessionViewModel: ObservableObject {
    
    @Published private(set) var session: InterviewSession?
    @Published private(set) var screenState: PracticeSessionScreenState = .loading
    
    @Published private(set) var elapsedRecordingTime: TimeInterval = 0 // record Time
    @Published private(set) var elapsedSessionTime: TimeInterval = 0 // record Time
    private var elapsedTimer: Timer?
    private var elapsedSessionTimer: Timer?
    
    var currentQuestionText: String {
        session?.currentQuestion.text ?? ""
    }
    
    var currentQuestionNumber: Int {
        guard let session = session else { return 0 }
        return progressService.currentQuestionNumber(session: session)
    }
    
    var totalQuestions: Int {
        session?.configuration.maxQuestions ?? 0
    }
    
    var feedback: InterviewFeedback? {
        session?.feedback
    }
    
    private let configuration: InterviewConfiguration
    
    private let startUseCase: StartInterviewUseCaseProtocol
    private let submitUseCase: SubmitAnswerUseCaseProtocol
    private let resumeUseCase: ResumeInterviewUseCaseProtocol
    private let finishUseCase: FinishInterviewUseCaseProtocol
    private let cancelUseCase: CancelInterviewUseCaseProtocol
    private let validationService: InterviewValidationServicing
    private let progressService: InterviewProgressServicing
    
    private let recordingService: AudioRecordingServicing
    private let silenceService: SilenceDetectionServicing
    private let speechService: SpeechPlaybackServicing
    
    
    private let silenceThreshold: Float = 0.08 // Audio level
    
    
    
    init(
        configuration: InterviewConfiguration,
        startUseCase: StartInterviewUseCaseProtocol,
        submitUseCase: SubmitAnswerUseCaseProtocol,
        resumeUseCase: ResumeInterviewUseCaseProtocol,
        finishUseCase: FinishInterviewUseCaseProtocol,
        cancelUseCase: CancelInterviewUseCaseProtocol,
        validationService: InterviewValidationServicing,
        progressService: InterviewProgressServicing,
        recordingService: AudioRecordingServicing,
        silenceService: SilenceDetectionServicing,
        speechService: SpeechPlaybackServicing
    ) {
        self.configuration = configuration
        self.startUseCase = startUseCase
        self.submitUseCase = submitUseCase
        self.resumeUseCase = resumeUseCase
        self.finishUseCase = finishUseCase
        self.cancelUseCase = cancelUseCase
        self.validationService = validationService
        self.progressService = progressService
        self.recordingService = recordingService
        self.silenceService = silenceService
        self.speechService = speechService
        
        // Assigned last, after every stored property is set, so `self` is fully valid.
        self.recordingService.delegate = self
        self.silenceService.delegate = self
        self.speechService.delegate = self
    }
    
    //MARK: OnError
    func onError(error: Error) async{
        
        if let interviewError = error as? InterviewError{
            switch interviewError{
            case .questionLimitReached, .interviewTimeExpired:
                await finish()
            case .networkUnavailable, .repositoryError(_), .unknown(_), .invalidState(_, _),.sessionNotFound:
                await resumeAfterNetworkDrop()
            }
        }else if let peechRecognitionError = error as? SpeechRecognitionError{
            switch peechRecognitionError{
                
            case .authorizationDenied,.recognizerUnavailable,.noSpeechDetected, .transcriptionFailed(_):
                await resumeAfterNetworkDrop()
            }
            
        }
    }
    
    // MARK: - Lifecycle
    func start() async {
        startSessionTimer()
        
        screenState = .loading
        do {
            let startInterviewSessionRequest = StartInterviewSessionRequest(trackId: 555555, questionCount: configuration.maxQuestions, durationMinutes: Int(configuration.maxInterviewDuration))
            let newSession = try await startUseCase.execute(startInterviewSessionRequest: startInterviewSessionRequest)
            fillCurrentSesstionWithNewData(newSession: newSession)
            beginAITurn(question: newSession.currentQuestion)
        } catch {
            screenState = .error(InterviewError.map(error))
        }
    }
    
    private func fillCurrentSesstionWithNewData(newSession: NewSession){
        
        session = InterviewSession(id: String(newSession.sessionId), status: .aiAsking, currentQuestionIndex: 0, questions: [newSession.currentQuestion], answers: [], configuration: configuration, currentQuestion: newSession.currentQuestion)
        
        guard var tempSession = session else{
            return
        }
        
        print("newSession: \(newSession)")
        tempSession.currentQuestion = newSession.currentQuestion
        tempSession.id = String(newSession.sessionId)
        tempSession.configuration = configuration
        
        
    }
    
    //MARK: Begin With AI
    private func beginAITurn(question: InterviewQuestion?) {
        guard let question = question else {
            Task {
                await finish() }
            return
        }
        print("Ai Turn")
        screenState = .aiTurn
        
        Task{
            do {
                try await speechService.speak(text: question.text)
                beginWaitingForAnswer()
            }catch let speechError as SpeechPlaybackError{
                print("AI Can't Speak due: \(speechError.localizedDescription)")
                try await Task.sleep(nanoseconds: 3000000000)
                beginWaitingForAnswer()
            }catch {
                print("Ai Can't Speak Now")
                try await Task.sleep(nanoseconds: 3000000000)
                beginWaitingForAnswer()
            }
        }
    }
    
    //MARK: Click On Start Answering
    func startAnswering() {
        print("Current Session \(session?.status ?? .cancelled)")
        guard let currentSession = session else {
            screenState = .error(InterviewError.unknown("Can Not Answering This Q Now"))
            return
        }
        
        guard validationService.canStartRecording(session: currentSession) else {
            screenState = .error(InterviewError.unknown("Can Not Answering This Q Now"))
            return
        }
        
        session?.status = .recording
        screenState = .recording(silenceWarning: nil) // send to the ui the remaing number but if the silcen start
        elapsedRecordingTime = 0
        
        do {
            try recordingService.startRecording()
            try silenceService.startMonitoring(
                silenceTimeout: currentSession.configuration.silenceTimeout,
                silenceThreshold: silenceThreshold
            )
            startElapsedTimer()
        } catch {
            let message = (error as? AudioRecordingError)?.localizedDescription
            ?? InterviewError.map(error).localizedDescription
            screenState = .error(InterviewError.unknown(message))
        }
    }
    
    func submitAnswerManually() {
        finishRecordingAndSubmit()
    }
    
    
    func resumeAfterNetworkDrop() async {
        guard let tempSession = session else { return }
        screenState = .reconnecting
        stopEverythingForReconnect()
        do {
            let restored = try await resumeUseCase.execute(session: tempSession)
            session = restored
            resumeUIState(for: restored)
        } catch {
            screenState = .error(InterviewError.map(error))
        }
    }
    
    func cancel() async {
        stopEverythingForReconnect()
        guard let sessionId = session?.id else { return }
        try? await cancelUseCase.execute(sessionId: sessionId)
    }
    
    
    private func beginWaitingForAnswer() {
        //        speechService.stop()
        session?.status = .waitingForAnswer
        screenState = .waitingForAnswer
    }
    
    private func finishRecordingAndSubmit() {
        guard let currentSession = session,
              validationService.canSubmitAnswer(session: currentSession) else {
            return
        }
        
        stopElapsedTimer()
        silenceService.stopMonitoring()
        
        let audioURL: AudioRecordingResult
        do {
            audioURL = try recordingService.stopRecording()
            print("AudioURL: \(audioURL.fileURL)")
            print("AudioDuration: \(audioURL.duration)")
        } catch {
            let message = (error as? AudioRecordingError)?.localizedDescription
            ?? InterviewError.map(error).localizedDescription
            screenState = .error(InterviewError.unknown(message))
            return
        }
        
        screenState = .submittingAnswer
        
        Task {
            do {
                guard let tempSession = session else{
                    return
                }
                
                let submitRequest = SubmitAnswerRequest(sessionId: tempSession.id, questionId: tempSession.currentQuestion.id, transcript: nil, sessionElapsedSeconds: Int(elapsedSessionTime / 60), durationMs: Int(elapsedRecordingTime / 60) , audioUrlAsString: audioURL.fileURL.absoluteString, audioUrl: audioURL.fileURL, words: nil)
                

                let updatedSession = try await submitUseCase.execute(session: tempSession, submitAnsRequest: submitRequest)
                session = updatedSession
                if updatedSession.status == .completed {
                    print("Session Done")
                    screenState = .completed
                } else {
                    print("New Q")
                    beginAITurn(question: updatedSession.currentQuestion)
                }
            } catch {
                screenState = .error(InterviewError.map(error))
            }
        }
    }
    
    func finish() async {
        stopSessionTimer()
        guard let sessionId = session?.id else { return }
        screenState = .submittingAnswer
        do {
            let finalFeedback = try await finishUseCase.execute(finishInterviewRequest: FinishInterviewRequest(sessionID: sessionId))
            session?.feedback = finalFeedback
            session?.status = .completed
            screenState = .completed
        } catch {
            screenState = .error(InterviewError.map(error))
        }
    }
    
    private func resumeUIState(for session: InterviewSession) {
        switch session.status {
        case .aiAsking:
            beginAITurn(question: session.currentQuestion)
        case .waitingForAnswer:
            beginWaitingForAnswer()
        case .recording:
            // Backend can't hand us back locally-recorded audio — safest recovery is
            // to re-ask the current question rather than pretend a recording exists.
            beginAITurn(question: session.currentQuestion)
        case .completed:
            screenState = .completed
        default:
            beginAITurn(question: session.currentQuestion)
        }
    }
    
    private func stopEverythingForReconnect() {
        stopElapsedTimer()
        silenceService.stopMonitoring()
        speechService.stop()
        if recordingService.isRecording {
            _ = try? recordingService.stopRecording()
        }
    }
    
    // MARK: - Elapsed time display
    private func startElapsedTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.elapsedRecordingTime += 1
            }
        }
    }
    
    private func startSessionTimer() {
        elapsedSessionTimer?.invalidate()
        elapsedSessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.elapsedSessionTime += 1
            }
        }
    }
    
    private func stopElapsedTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = nil
    }
    
    private func stopSessionTimer() {
        elapsedSessionTimer?.invalidate()
        elapsedSessionTimer = nil
    }
}

// MARK: - AudioRecordingServiceDelegate

extension PracticeSessionViewModel: AudioRecordingServiceDelegate {
    nonisolated func audioRecordingService(_ service: AudioRecordingService, didUpdateLevel level: Float) {
        Task { @MainActor in
            self.silenceService.processLevel(level)
        }
    }
    
    nonisolated func audioRecordingService(_ service: AudioRecordingService, didFailWithError error: AudioRecordingError) {
        Task { @MainActor in
            self.screenState = .error(InterviewError.unknown(error.localizedDescription))
        }
    }
}

// MARK: - SilenceDetectionServiceDelegate

extension PracticeSessionViewModel: SilenceDetectionServiceDelegate {
    nonisolated func silenceDetectionServiceDidDetectSilenceStart(_ service: SilenceDetectionService) {
        Task { @MainActor in
            self.screenState = .recording(silenceWarning: SilenceWarning(remainingSeconds: 0))
        }
    }
    
    nonisolated func silenceDetectionServiceDidResumeSpeech(_ service: SilenceDetectionService) {
        Task { @MainActor in
            self.screenState = .recording(silenceWarning: nil)
        }
    }
    
    nonisolated func silenceDetectionService(_ service: SilenceDetectionService, didUpdateCountdown remaining: TimeInterval) {
        Task { @MainActor in
            self.screenState = .recording(silenceWarning: SilenceWarning(remainingSeconds: Int(remaining.rounded(.up))))
        }
    }
    
    /// The auto-submit trigger — same destination as the manual "Submit Answering" tap.
    nonisolated func silenceDetectionServiceDidTimeout(_ service: SilenceDetectionService) {
        Task { @MainActor in
            self.finishRecordingAndSubmit()
        }
    }
}

// MARK: - SpeechPlaybackServiceDelegate

extension PracticeSessionViewModel: SpeechPlaybackServiceDelegate {
    nonisolated func speechPlaybackServiceDidStart(_ service: SpeechPlaybackService) {
        Task { @MainActor in
            self.screenState = .aiTurn
        }
    }
    
    nonisolated func speechPlaybackServiceDidFinish(_ service: SpeechPlaybackService) {
        Task { @MainActor in
            self.beginWaitingForAnswer()
        }
    }
    
    nonisolated func speechPlaybackService(_ service: SpeechPlaybackService, didFailWithError error: SpeechPlaybackError) {
        Task { @MainActor in
            // Same fallback as a throw from speak(): let the user answer even if the
            // AI voice failed — the question text is already on screen.
            self.beginWaitingForAnswer()
        }
    }
}
