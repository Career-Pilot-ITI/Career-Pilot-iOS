import Foundation

struct SubmitAnswerRequest{
    let session: InterviewSession
    let audioReference: AudioReference
    let transcript: String
    let duration: TimeInterval
    
}

protocol SubmitAnswerUseCaseProtocol {
    func execute(submitAnsRequest: SubmitAnswerRequest) async throws -> InterviewSession
}


actor SubmitAnswerUseCase: SubmitAnswerUseCaseProtocol {
    private let repository: InterviewRepository
    private let validationService: InterviewValidationServicing
    private var isSubmitting = false
    
    init(repository: InterviewRepository, validationService: InterviewValidationServicing) {
        self.repository = repository
        self.validationService = validationService
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
        
        let outcome: SubmitAnswerOutcome
        do {
            outcome = try await repository.submitAnswer(
                sessionId: submitAnsRequest.session.id,
                questionId: question.id,
                audioReference: submitAnsRequest.audioReference,
                duration: submitAnsRequest.duration
            )
        } catch {
            throw InterviewError.map(error)
        }
        
        var updatedSession = submitAnsRequest.session
        let answer = InterviewAnswer(
            questionId: question.id,
            audioReference: submitAnsRequest.audioReference,
            duration: submitAnsRequest.duration,
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
