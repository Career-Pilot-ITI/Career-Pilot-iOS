import Foundation

protocol InterviewProgressServicing: Sendable {
    func currentQuestionNumber(session: InterviewSession) -> Int
    func questionsRemaining(session: InterviewSession) -> Int
    func completionPercentage(session: InterviewSession) -> Double
}

final class InterviewProgressService: InterviewProgressServicing, Sendable {

    func currentQuestionNumber(session: InterviewSession) -> Int {
        session.currentQuestionIndex + 1
    }

    func questionsRemaining(session: InterviewSession) -> Int {
        max(0, (session.configuration.maxQuestions - (session.currentQuestionIndex + 1) - 1))
    }

    func completionPercentage(session: InterviewSession) -> Double {
        guard session.configuration.maxQuestions > 0 else { return 0 }
        return Double(session.currentQuestionIndex) / Double(session.configuration.maxQuestions)
    }
}
