import Foundation

enum SubmitAnswerOutcome: Equatable, Sendable {
    case nextQuestion(InterviewQuestion)
    case interviewCompleted(InterviewFeedback)
}

enum AudioReference: Equatable, Sendable {
    case localFile(URL)
    case remoteURL(URL)
}

struct InterviewAnswer: Equatable, Sendable {
    let questionId: String
    let audioReference: AudioReference
    let duration: TimeInterval
    let submittedAt: Date
}
