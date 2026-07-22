import Foundation

protocol InterviewRepository: Sendable {
    func startInterview(configuration: InterviewConfiguration) async throws -> InterviewSession
    func submitAnswer(submitAnswerRequest: SubmitAnswerRequest) async throws -> SubmitAnswerOutcome
    func resumeInterview(session: InterviewSession) async throws -> InterviewSession
    func finishInterview(finishInterviewRequest: FinishInterviewRequest) async throws -> InterviewFeedback
    func cancelInterview(sessionId: String) async throws
}
