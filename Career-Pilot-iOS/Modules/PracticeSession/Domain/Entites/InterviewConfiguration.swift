import Foundation

/// Business rules for a session.
struct InterviewConfiguration: Equatable, Sendable {
    let maxQuestions: Int
    let maxAnswerDuration: TimeInterval
    let maxInterviewDuration: TimeInterval
    let silenceTimeout: TimeInterval
    let trackID: Int
}

