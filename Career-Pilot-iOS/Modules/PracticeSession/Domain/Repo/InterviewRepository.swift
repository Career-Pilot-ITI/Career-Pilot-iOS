import Foundation

protocol InterviewRepository: Sendable {
    func startInterview(configuration: InterviewConfiguration) async throws -> InterviewSession
    func submitAnswer(sessionId: String, questionId: String, audioReference: AudioReference, duration: TimeInterval) async throws -> SubmitAnswerOutcome
    func resumeInterview(sessionId: String) async throws -> InterviewSession
    func finishInterview(sessionId: String) async throws -> InterviewFeedback
    func cancelInterview(sessionId: String) async throws
}
