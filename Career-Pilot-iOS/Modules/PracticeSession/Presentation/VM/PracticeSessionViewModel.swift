//
//  PracticeSessionViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation

enum PracticeSessionScreenState {
    case loading
    case aiTurn
    case waitingForAnswer
    case recording(silenceWarning: SilenceWarning?)
    case submittingAnswer
    case reconnecting
    case completed
    case error(Error)
}

struct SilenceWarning: Equatable {
    let remainingSeconds: Int
}

@MainActor
final class PracticeSessionViewModel: ObservableObject {

    @Published private(set) var session: InterviewSession?
    @Published private(set) var screenState: PracticeSessionScreenState = .loading

    @Published private(set) var elapsedRecordingTime: TimeInterval = 0
    @Published private(set) var elapsedSessionTime: TimeInterval = 0
    private var elapsedTimer: Timer?
    private var elapsedSessionTimer: Timer?

    // In-flight work we need to be able to cancel on reconnect/cancel/dealloc
    private var aiTurnTask: Task<Void, Never>?
    private var submitTask: Task<Void, Never>?

    var currentQuestionText: String {
        session?.currentQuestion.text ?? ""
    }

    var currentQuestionNumber: Int {
        guard let session else { return 0 }
        return progressService.currentQuestionNumber(session: session)
    }

    var totalQuestions: Int {
        (
            session?.configuration.maxQuestions  ?? 0
        ) - 1
    }

    var questionsRemaining: Int {
        guard let session else { return 0 }
        return progressService.questionsRemaining(session: session)
    }

    var completionPercentage: Double {
        guard let session else { return 0 }
        return progressService.completionPercentage(session: session)
    }

    var feedback: InterviewFeedback {
        guard let feedback = session?.feedback else{
            return InterviewFeedback.empty
        }
        return feedback
    }

    private var interviewType: InterviewType

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
    private let speechRecognitionService: SpeechRecognitionServicing

    private let silenceThreshold: Float = 0.08

    init(
        interviewType: InterviewType = .Classic,
        startUseCase: StartInterviewUseCaseProtocol,
        submitUseCase: SubmitAnswerUseCaseProtocol,
        resumeUseCase: ResumeInterviewUseCaseProtocol,
        finishUseCase: FinishInterviewUseCaseProtocol,
        cancelUseCase: CancelInterviewUseCaseProtocol,
        validationService: InterviewValidationServicing,
        progressService: InterviewProgressServicing,
        recordingService: AudioRecordingServicing,
        silenceService: SilenceDetectionServicing,
        speechService: SpeechPlaybackServicing,
        speechRecognitionService: SpeechRecognitionServicing
    ) {
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
        self.speechRecognitionService = speechRecognitionService

        self.interviewType = interviewType
        self.recordingService.delegate = self
        self.silenceService.delegate = self
        self.speechService.delegate = self
    }

    deinit {
        elapsedTimer?.invalidate()
        elapsedSessionTimer?.invalidate()
    }

    // MARK: - Single error func
    func onError(error: Error) async {
        print("onError: \(error)")
        screenState = .loading

        if let interviewError = error as? InterviewError {
            await handle(interviewError)
        } else if let speechRecognitionError = error as? SpeechRecognitionError {
            handle(speechRecognitionError)
        } else if let speechPlaybackError = error as? SpeechPlaybackError {
            print("Speech playback failed: \(speechPlaybackError.localizedDescription)")
            beginWaitingForAnswer()
        } else {
            screenState = .error(InterviewError.map(error))
        }
    }

    private func handle(_ error: InterviewError) async {
        switch error {
        case .questionLimitReached, .interviewTimeExpired, .sessionQuotaExceeded:
            guard session != nil else {
                screenState = .error(error)
                return
            }
            await finish()

        case .networkUnavailable, .serverError, .unknown, .invalidState, .sessionNotFound:
            guard session != nil else {
                // Nothing to resume — e.g. start() itself failed before a session existed.
                screenState = .error(error)
                return
            }
            await resumeAfterNetworkDrop()
        }
    }

    private func handle(_ error: SpeechRecognitionError) {
        switch error {
        case .authorizationDenied, .recognizerUnavailable, .noSpeechDetected, .transcriptionFailed:
            beginWaitingForAnswer()
        }
    }

    // MARK: - Lifecycle
    func start() async {
        startSessionTimer()
        screenState = .loading
        do {
            let newSession = try await startUseCase.execute(interviewConfiguration: interviewType.interviewConfiguration)
            applyNewSession(newSession)
            beginAITurn(question: newSession.currentQuestion)
        } catch {
            screenState = .error(error)
        }
    }

    private func applyNewSession(_ newSession: NewSession) {
        session = InterviewSession(
            id: String(newSession.sessionId),
            status: .aiAsking,
            currentQuestionIndex: 0,
            questions: [newSession.currentQuestion],
            answers: [],
            configuration: interviewType.interviewConfiguration,
            currentQuestion: newSession.currentQuestion
        )
    }

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
        guard let currentSession = session,
              validationService.canStartRecording(session: currentSession) else {
            screenState = .error(InterviewError.unknown("Can't answer this question right now."))
            return
        }

        session?.status = .recording
        screenState = .recording(silenceWarning: nil)
        elapsedRecordingTime = 0

        do {
            try recordingService.startRecording()
            try silenceService.startMonitoring(
                silenceTimeout: currentSession.configuration.silenceTimeout,
                silenceThreshold: silenceThreshold
            )
            startElapsedTimer()
        } catch {
            screenState = .error(error)
        }
    }

    func submitAnswerManually() {
//        screenState = .error(InterviewError.networkUnavailable)
        finishRecordingAndSubmit()
    }

    func resumeAfterNetworkDrop() async {
        guard let tempSession = session else { return }
        screenState = .reconnecting
        stopEverythingForReconnect()
        do {
            let restored = try await resumeUseCase.execute(session: tempSession)
            session = restored
            print("Let's resumeAfterNetworkDrop: \(session!)")
            resumeUIState(for: restored)
        } catch {
            // Don't route back through onError here — a failed resume attempt
            // retrying itself would loop. Dead-end on .error is correct.
            screenState = .error(InterviewError.map(error))
        }
    }

    func cancel() async {
        aiTurnTask?.cancel()
        submitTask?.cancel()
        stopEverythingForReconnect()
        guard let sessionId = session?.id else { return }
        try? await cancelUseCase.execute(sessionId: sessionId)
    }

    private func beginWaitingForAnswer() {
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

        let audioResult: AudioRecordingResult
        do {
            audioResult = try recordingService.stopRecording()
        } catch {
            screenState = .error(InterviewError.unknown(
                (error as? AudioRecordingError)?.localizedDescription
                    ?? InterviewError.map(error).localizedDescription
            ))
            return
        }

        screenState = .submittingAnswer

        submitTask?.cancel()
        submitTask = Task {
            guard let tempSession = session else { return }

            do {
                let transcript: String = try await speechRecognitionService.transcribe(audioAt: audioResult.fileURL)
                let submitRequest = SubmitAnswerRequest(
                    sessionId: tempSession.id,
                    questionId: tempSession.currentQuestion.id,
                    transcript: transcript,
                    sessionElapsedSeconds: Int(elapsedSessionTime),
                    durationMs: Int(elapsedRecordingTime * 1000),
                    audioAsUrl: audioResult.fileURL,
                    audioUrl: audioResult.fileURL.absoluteString,
                    words: nil
                )

                let updatedSession = try await submitUseCase.execute(session: tempSession, submitAnsRequest: submitRequest)
                session = updatedSession

                if updatedSession.status == .completed {
                    screenState = .completed
                } else {
                    beginAITurn(question: updatedSession.currentQuestion)
                }
            } catch {
                screenState = .error(error)
            }
        }
    }

    func finish() async {
        screenState = .loading
        stopSessionTimer()
        guard let sessionId = session?.id else {
            screenState = .error(InterviewError.unknown("Can't finish — no active session."))
            return
        }
        screenState = .submittingAnswer
        do {
            let finalFeedback = try await finishUseCase.execute(finishInterviewRequest: FinishInterviewRequest(sessionID: sessionId))
            session?.feedback = finalFeedback
            session?.status = .completed
            screenState = .completed
        } catch {
            screenState = .error(error)
        }
    }

    private func resumeUIState(for session: InterviewSession) {
        switch session.status {
        case .aiAsking:
            beginAITurn(question: session.currentQuestion)
        case .waitingForAnswer:
            beginWaitingForAnswer()
        case .recording:
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
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.elapsedRecordingTime += 1
            }
        }
    }

    private func startSessionTimer() {
        elapsedSessionTimer?.invalidate()
        elapsedSessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
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
        Task { @MainActor in self.silenceService.processLevel(level) }
    }

    nonisolated func audioRecordingService(_ service: AudioRecordingService, didFailWithError error: AudioRecordingError) {
        Task { @MainActor in await self.onError(error: InterviewError.unknown(error.localizedDescription)) }
    }
}

// MARK: - SilenceDetectionServiceDelegate
extension PracticeSessionViewModel: SilenceDetectionServiceDelegate {
    nonisolated func silenceDetectionServiceDidDetectSilenceStart(_ service: SilenceDetectionService) {
        Task { @MainActor in self.screenState = .recording(silenceWarning: SilenceWarning(remainingSeconds: 0)) }
    }

    nonisolated func silenceDetectionServiceDidResumeSpeech(_ service: SilenceDetectionService) {
        Task { @MainActor in self.screenState = .recording(silenceWarning: nil) }
    }

    nonisolated func silenceDetectionService(_ service: SilenceDetectionService, didUpdateCountdown remaining: TimeInterval) {
        Task { @MainActor in
            self.screenState = .recording(silenceWarning: SilenceWarning(remainingSeconds: Int(remaining.rounded(.up))))
        }
    }

    nonisolated func silenceDetectionServiceDidTimeout(_ service: SilenceDetectionService) {
        Task { @MainActor in self.submitAnswerManually() }
    }
}

// MARK: - SpeechPlaybackServiceDelegate
// NOTE: as implemented today, SpeechPlaybackService never actually calls
// didFinish/didFailWithError on this delegate (its AVSpeechSynthesizerDelegate
// only resumes the internal continuation). These are kept for when that's
// wired up, but beginAITurn's own do/catch is currently the real path.
extension PracticeSessionViewModel: SpeechPlaybackServiceDelegate {
    nonisolated func speechPlaybackServiceDidStart(_ service: SpeechPlaybackService) {
        Task { @MainActor in self.screenState = .aiTurn }
    }

    nonisolated func speechPlaybackServiceDidFinish(_ service: SpeechPlaybackService) {
        Task { @MainActor in self.beginWaitingForAnswer() }
    }

    nonisolated func speechPlaybackService(_ service: SpeechPlaybackService, didFailWithError error: SpeechPlaybackError) {
        Task { @MainActor in await self.onError(error: error) }
    }
}
