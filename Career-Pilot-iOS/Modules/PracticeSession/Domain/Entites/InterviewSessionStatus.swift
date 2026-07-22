import Foundation

enum InterviewSessionStatus: String, Equatable, Sendable, Encodable {
    case notStarted
    case aiAsking
    case waitingForAnswer
    case recording
    case submittingAnswer
    case completed
    case cancelled
    case paused
}
