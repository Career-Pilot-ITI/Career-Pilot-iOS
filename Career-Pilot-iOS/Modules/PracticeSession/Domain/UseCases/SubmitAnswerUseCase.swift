import Foundation

struct SubmitAnswerRequest: Encodable {
    let session: InterviewSession
    var transcript: String?
    let sessionElapsedSeconds: Int?
    let durationMs: Int
    let audioUrlAsString: String
    let audioUrl: URL
    let words: [WordTiming]?
}

struct WordTiming: Encodable {
    let word: String
    let startMs: Int
    let endMs: Int
}

protocol SubmitAnswerUseCaseProtocol {
    func execute(submitAnsRequest: SubmitAnswerRequest) async throws -> InterviewSession
}


actor SubmitAnswerUseCase: SubmitAnswerUseCaseProtocol {
    private let repository: InterviewRepository
    private let validationService: InterviewValidationServicing
    private let speechRecognitionService: SpeechRecognitionService
    private var isSubmitting = false
    
    
    init(repository: InterviewRepository, validationService: InterviewValidationServicing, speechRecognitionService: SpeechRecognitionService) {
        self.repository = repository
        self.validationService = validationService
        self.speechRecognitionService = speechRecognitionService
    }
    
    func execute(submitAnsRequest: SubmitAnswerRequest) async throws -> InterviewSession {
        
        guard let question = submitAnsRequest.session.currentQuestion else {
            throw InterviewError.sessionNotFound
        }
        
        guard validationService.canSubmitAnswer(session: submitAnsRequest.session) else {
            throw InterviewError.invalidState(current: submitAnsRequest.session.status, attempted: "submitAnswer")
        }
        
        guard !isSubmitting else {
            throw InterviewError.invalidState(current: submitAnsRequest.session.status, attempted: "submitAnswer (already in flight)")
        }
        
        
        //Start to subitting the ans
        isSubmitting = true
        defer { isSubmitting = false }
        
        var updatedSubmitAnsRequest: SubmitAnswerRequest = submitAnsRequest
        
        updatedSubmitAnsRequest.transcript = try await speechRecognitionService.transcribe(audioAt: submitAnsRequest.audioUrl)
        
        let outcome: SubmitAnswerOutcome
        do {
            outcome = try await repository.submitAnswer(submitAnswerRequest: updatedSubmitAnsRequest)
        } catch {
            throw InterviewError.map(error)
        }
        
        var updatedSession = submitAnsRequest.session
        let answer = InterviewAnswer(
            questionId: question.id,
            audioURL: submitAnsRequest.audioUrl,
            duration: TimeInterval(submitAnsRequest.durationMs * 60),
            submittedAt: Date()
        )
        updatedSession.answers.append(answer)
        
        
        switch outcome {
        case .nextQuestion(let nextQuestion):
            updatedSession.questions.append(nextQuestion)
            updatedSession.currentQuestionIndex += 1
            updatedSession.status = .aiAsking
        case .interviewCompleted(let feedback):
            updatedSession.feedback = feedback
            updatedSession.status = .completed
        }
        
        return updatedSession
    }
}
