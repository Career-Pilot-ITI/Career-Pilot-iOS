//
//  PracticeSessionViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation
import AVFoundation

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

/// State of the post-interview Vision analysis pass. Only meaningful when mode == .video.
enum VisualAnalysisState: Equatable {
    case idle
    case analyzing
    case completed(framesAnalyzed: Int, framesSkipped: Int)
    case failed
}

// MARK: - PracticeSessionViewModel

@MainActor
final class PracticeSessionViewModel: ObservableObject {

    // MARK: Published state

    @Published private(set) var session: InterviewSession?
    @Published private(set) var screenState: PracticeSessionScreenState = .loading

    @Published private(set) var elapsedRecordingTime: TimeInterval = 0
    @Published private(set) var elapsedSessionTime: TimeInterval = 0

    @Published private(set) var isVideoReady: Bool = false

    /// Result of the post-interview Vision pass, driven from finish(). Stays .idle for
    /// audio-only sessions.
    @Published private(set) var visualAnalysisState: VisualAnalysisState = .idle

    /// Deterministic scoring computed from frameObservations once analysis completes.
    @Published private(set) var presenceScore: InterviewPresenceScore = InterviewPresenceScore.empty

    private var elapsedTimer: Timer?
    private var elapsedSessionTimer: Timer?
    private var aiTurnTask: Task<Void, Never>?
    private var submitTask: Task<Void, Never>?

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

    private let frameCaptureService: VideoFrameCaptureServicing?
    private let frameAnalysisService: VisionFrameAnalyzing?
    private let metricsEngine: VisualMetricsEngineProtocol

    private let silenceThreshold: Float = 0.08

    private var homeCoordinator: AppCoordinator<HomeRoute>?
    private var interviewType: InterviewType

    private(set) var capturedFrames: [CapturedFrame] = []

    /// Result of the post-interview analysis. Empty until visualAnalysisState reaches .completed.
    private(set) var frameObservations: [FrameObservation] = []

    init(
        interviewType: InterviewType = .classic,
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
        speechRecognitionService: SpeechRecognitionServicing,
        frameCaptureService: VideoFrameCaptureServicing? = VideoFrameCaptureService(samplingStrategy: FrameSamplingStrategy(minimumInterval: 5)),
        frameAnalysisService: VisionFrameAnalyzing? = VisionFrameAnalysisService(),
        metricsEngine: VisualMetricsEngineProtocol = VisualMetricsEngine()
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
        self.frameCaptureService = frameCaptureService
        self.frameAnalysisService = frameAnalysisService
        self.metricsEngine = metricsEngine

        self.interviewType = interviewType
        self.recordingService.delegate = self
        self.silenceService.delegate = self
        self.speechService.delegate = self
        self.frameCaptureService?.delegate = self
    }

    deinit {
        elapsedTimer?.invalidate()
        elapsedSessionTimer?.invalidate()
        frameCaptureService?.teardownSession()
    }

    var currentQuestionText: String {
        session?.currentQuestion.text ?? ""
    }

    var currentQuestionNumber: Int {
        guard let session else { return 0 }
        return progressService.currentQuestionNumber(session: session)
    }

    var totalQuestions: Int {
        (session?.configuration.maxQuestions ?? 0) - 1
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
        guard let feedback = session?.feedback else {
            print("No Feedback yet")
            return InterviewFeedback.empty
        }
        return feedback
    }

    func attach(coordinator: AppCoordinator<HomeRoute>) {
        guard homeCoordinator == nil else { return }
        self.homeCoordinator = coordinator
    }
}

// MARK: - Lifecycle (start / AI turn / resume UI)

extension PracticeSessionViewModel {

    func start(trackId: Int, interviewType: InterviewType) async {
        self.interviewType = interviewType

        startSessionTimer()
        screenState = .loading

        if interviewType.interviewConfiguration.mode == .video {
            await configureVideoIfNeeded()
        }

        do {
            let newSession = try await startUseCase.execute(interviewConfiguration: interviewType.interviewConfiguration, trackId: trackId)
            applyNewSession(newSession)
            beginAITurn(question: newSession.currentQuestion)
        } catch {
            screenState = .error(error)
        }
    }

    fileprivate func applyNewSession(_ newSession: NewSession) {
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

    fileprivate func beginAITurn(question: InterviewQuestion?) {
        guard let question = question else {
            Task { await finish() }
            return
        }
        print("Ai Turn")
        screenState = .aiTurn

        Task {
            do {
                try await speechService.speak(text: question.text)
                beginWaitingForAnswer()
            } catch let speechError as SpeechPlaybackError {
                print("AI Can't Speak due: \(speechError.localizedDescription)")
                try await Task.sleep(nanoseconds: 3_000_000_000)
                beginWaitingForAnswer()
            } catch {
                print("Ai Can't Speak Now")
                try await Task.sleep(nanoseconds: 3_000_000_000)
                beginWaitingForAnswer()
            }
        }
    }

    fileprivate func resumeUIState(for session: InterviewSession) {
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
}

// MARK: - Answering flow (record / submit)

extension PracticeSessionViewModel {

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

            if interviewType.interviewConfiguration.mode == .video && isVideoReady {
                frameCaptureService?.startCapturing()
            }
        } catch {
            screenState = .error(error)
        }
    }

    func submitAnswerManually() {
        finishRecordingAndSubmit()
    }

    fileprivate func beginWaitingForAnswer() {
        session?.status = .waitingForAnswer
        screenState = .waitingForAnswer
    }

    fileprivate func finishRecordingAndSubmit() {
        guard let currentSession = session,
              validationService.canSubmitAnswer(session: currentSession) else {
            return
        }

        stopElapsedTimer()
        silenceService.stopMonitoring()

        if interviewType.interviewConfiguration.mode == .video && isVideoReady {
            let questionFrames = frameCaptureService?.stopCapturing() ?? []
            capturedFrames.append(contentsOf: questionFrames)
        }

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
}

// MARK: - Errors, recovery & termination

extension PracticeSessionViewModel {

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

    fileprivate func handle(_ error: InterviewError) async {
        switch error {
        case .questionLimitReached, .interviewTimeExpired, .sessionQuotaExceeded, .unauthorized:
            guard session != nil else {
                homeCoordinator?.popToRoot()
                return
            }
            await finish()

        case .networkUnavailable, .serverError, .unknown, .invalidState, .sessionNotFound:
            guard session != nil else {
                await resumeAfterNetworkDrop()
                return
            }
            await resumeAfterNetworkDrop()
        }
    }

    fileprivate func handle(_ error: SpeechRecognitionError) {
        switch error {
        case .authorizationDenied, .recognizerUnavailable, .noSpeechDetected, .transcriptionFailed:
            beginWaitingForAnswer()
        }
    }

    func resumeAfterNetworkDrop() async {
        guard let tempSession = session else {
            screenState = .error(InterviewError.sessionNotFound)
            return
        }
        screenState = .reconnecting
        stopEverythingForReconnect()
        do {
            let restored = try await resumeUseCase.execute(session: tempSession)
            session = restored
            print("Let's resumeAfterNetworkDrop: \(session!)")
            resumeUIState(for: restored)
        } catch {
            screenState = .error(InterviewError.map(error))
        }
    }

    func cancel() async {
        aiTurnTask?.cancel()
        submitTask?.cancel()
        stopEverythingForReconnect()
        capturedFrames.removeAll()
        frameObservations.removeAll()
        presenceScore = InterviewPresenceScore.empty
        visualAnalysisState = .idle
        frameCaptureService?.teardownSession()
        guard let sessionId = session?.id else { return }
        try? await cancelUseCase.execute(sessionId: sessionId)
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
            
            if interviewType.interviewConfiguration.mode == .video {
                print("Tirgger runVisualAnalysisIfNeeded")
                Task { await self.runVisualAnalysisIfNeeded()
                    screenState = .completed
                }
            }else{
                screenState = .completed
            }
        } catch {
            screenState = .error(error)
        }
    }

    fileprivate func stopEverythingForReconnect() {
        stopElapsedTimer()
        silenceService.stopMonitoring()
        speechService.stop()
        if recordingService.isRecording {
            _ = try? recordingService.stopRecording()
        }
        if interviewType.interviewConfiguration.mode == .video && isVideoReady {
            let questionFrames = frameCaptureService?.stopCapturing() ?? []
            capturedFrames.append(contentsOf: questionFrames)
        }
    }
}

// MARK: - Video capture

extension PracticeSessionViewModel {
    var cameraSession: AVCaptureSession? {
        frameCaptureService?.previewSession
    }

    fileprivate func configureVideoIfNeeded() async {
        print("Configuring open the video...")
        guard let frameCaptureService, !frameCaptureService.isConfigured else {
            isVideoReady = frameCaptureService?.isConfigured ?? false
            print("Video not ready cause frameCaptureService isConfigured: \(String(describing: frameCaptureService?.isConfigured))")
            return
        }
        do {
            try await frameCaptureService.configureSessionIfNeeded()
            isVideoReady = true
        } catch {
            print("Video capture unavailable, continuing audio-only: \(error)")
            isVideoReady = false
        }
    }

    /// Runs after the interview finishes. Never fails the interview itself — worst case,
    /// visualAnalysisState ends up .failed and there's simply no video report later.
    fileprivate func runVisualAnalysisIfNeeded() async {
        print("Start visual analysis")
        guard let frameAnalysisService else {
            visualAnalysisState = .failed
            return
        }
        guard !capturedFrames.isEmpty else {
            visualAnalysisState = .completed(framesAnalyzed: 0, framesSkipped: 0)
            return
        }

        visualAnalysisState = .analyzing

        // Hand the frames off and drop our copy immediately — we don't need the images
        // themselves once Vision has extracted landmarks from them.
        let framesToAnalyze = capturedFrames
        capturedFrames.removeAll()

        let result = await frameAnalysisService.analyze(frames: framesToAnalyze)
        frameObservations = result.observations
        presenceScore = metricsEngine.calculateMetrics(from: result.observations) ?? InterviewPresenceScore.empty
        visualAnalysisState = .completed(framesAnalyzed: result.framesAnalyzed, framesSkipped: result.framesSkipped)
        
    }
}

// MARK: - Elapsed time display

extension PracticeSessionViewModel {

    fileprivate func startElapsedTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.elapsedRecordingTime += 1
            }
        }
    }

    fileprivate func startSessionTimer() {
        elapsedSessionTimer?.invalidate()
        elapsedSessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.elapsedSessionTime += 1
            }
        }
    }

    fileprivate func stopElapsedTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = nil
    }

    fileprivate func stopSessionTimer() {
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

// MARK: - VideoFrameCaptureServiceDelegate

extension PracticeSessionViewModel: VideoFrameCaptureServiceDelegate {
    nonisolated func videoFrameCaptureService(_ service: VideoFrameCaptureServicing, didFailWithError error: VideoCaptureError) {
        Task { @MainActor in
            print("Video capture failed, continuing audio-only: \(error)")
            self.isVideoReady = false
        }
    }
}

// MARK: - SpeechPlaybackServiceDelegate

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
