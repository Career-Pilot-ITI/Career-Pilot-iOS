import Foundation

enum InterviewMode: Hashable, Sendable {
    case audio
    case video
}

enum InterviewType: Hashable, Sendable {
    case classic
    case custom(
        maxQuestions: Int,
        maxAnswerDuration: TimeInterval,
        maxInterviewDuration: TimeInterval
    )
}


struct InterviewConfiguration: Equatable, Sendable {
    let mode: InterviewMode
    let maxQuestions: Int
    let maxAnswerDuration: TimeInterval
    let maxInterviewDuration: TimeInterval
    let silenceTimeout: TimeInterval
}
