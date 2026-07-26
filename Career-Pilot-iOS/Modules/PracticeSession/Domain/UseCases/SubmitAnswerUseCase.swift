import Foundation

protocol SubmitAnswerUseCaseProtocol {
    func execute(session: InterviewSession, submitAnsRequest: SubmitAnswerRequest) async throws -> InterviewSession
}


actor SubmitAnswerUseCase: SubmitAnswerUseCaseProtocol {
    private let repository: InterviewRepository
    private let userDataRepository: UserDataRepo
    private let validationService: InterviewValidationServicing
    private let speechRecognitionService: SpeechRecognitionServicing
    private var isSubmitting = false
    
    
    init(repository: InterviewRepository, userDataRepository: UserDataRepo, validationService: InterviewValidationServicing, speechRecognitionService: SpeechRecognitionServicing) {
        self.repository = repository
        self.userDataRepository = userDataRepository
        self.validationService = validationService
        self.speechRecognitionService = speechRecognitionService
    }
    
    func execute(session: InterviewSession, submitAnsRequest: SubmitAnswerRequest) async throws -> InterviewSession {
        
//        guard let question = session. else {
//            throw InterviewError.sessionNotFound
//        }
        
        guard validationService.canSubmitAnswer(session: session) else {
            throw InterviewError.invalidState(current: session.status, attempted: "submitAnswer")
        }
        
        guard !isSubmitting else {
            throw InterviewError.invalidState(current: session.status, attempted: "submitAnswer (already in flight)")
        }
        
        
        //Start to subitting the ans
        isSubmitting = true
        defer { isSubmitting = false }
        
        var updatedSubmitAnsRequest: SubmitAnswerRequest = submitAnsRequest

        //For getting the url from server
        updatedSubmitAnsRequest.audioUrl = try await userDataRepository.uploadUserFile(fileURL: submitAnsRequest.audioAsUrl, fileType: .Audio).url
        
        let outcome: SubmitAnswerOutcome
        do {
            print(updatedSubmitAnsRequest)
            outcome = try await repository.submitAnswer(submitAnswerRequest: updatedSubmitAnsRequest)
        } catch {
            throw InterviewError.map(error)
        }
        
        var updatedSession = session
        let answer = InterviewAnswer(
            questionId: submitAnsRequest.questionId,
            audioURL: submitAnsRequest.audioAsUrl,
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
