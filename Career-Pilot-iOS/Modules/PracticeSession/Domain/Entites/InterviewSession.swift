import Foundation

/// Aggregate root. Everything in this feature belongs to a session.
struct InterviewSession: Equatable, Sendable {
    let id: String
    var status: InterviewSessionStatus
    var currentQuestionIndex: Int
    var questions: [InterviewQuestion]
    var answers: [InterviewAnswer]
    let configuration: InterviewConfiguration
    var feedback: InterviewFeedback?

    var currentQuestion: InterviewQuestion? {
        guard questions.indices.contains(currentQuestionIndex) else { return nil }
        return questions[currentQuestionIndex]
    }
}
