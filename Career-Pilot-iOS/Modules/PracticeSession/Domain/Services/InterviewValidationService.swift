import Foundation


protocol InterviewValidationServicing: Sendable {
    func canSubmitAnswer(session: InterviewSession) -> Bool
    func canStartRecording(session: InterviewSession) -> Bool
    func hasReachedQuestionLimit(session: InterviewSession) -> Bool
    func hasInterviewExpired(session: InterviewSession, elapsedTime: TimeInterval) -> Bool
    func canResume(session: InterviewSession) -> Bool
}

final class InterviewValidationService: InterviewValidationServicing, Sendable {

    func canSubmitAnswer(session: InterviewSession) -> Bool {
        session.status == .recording
    }

    func canStartRecording(session: InterviewSession) -> Bool {
        session.status == .waitingForAnswer
    }

    func hasReachedQuestionLimit(session: InterviewSession) -> Bool {
        session.currentQuestionIndex >= session.configuration.maxQuestions
    }

    func hasInterviewExpired(session: InterviewSession, elapsedTime: TimeInterval) -> Bool {
        elapsedTime >= session.configuration.maxInterviewDuration
    }

    func canResume(session: InterviewSession) -> Bool {
        session.status == .paused
    }
}
