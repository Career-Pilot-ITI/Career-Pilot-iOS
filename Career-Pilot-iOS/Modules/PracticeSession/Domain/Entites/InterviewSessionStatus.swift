import Foundation

enum InterviewSessionStatus: String, Equatable, Sendable {
    case notStarted
    case aiAsking
    case waitingForAnswer
    case recording
    case submittingAnswer
    case completed
    case cancelled
    case paused
}
