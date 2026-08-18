import Foundation

enum InterviewMode: Hashable, Sendable {
    case audio
    case video
}

enum InterviewType: Hashable {
    case classic
    case custom(
        mode: InterviewMode,
        maxQuestions: Int,
        maxAnswerDuration: TimeInterval,
        maxInterviewDuration: TimeInterval
    )

    var interviewConfiguration: InterviewConfiguration {
        switch self {
        case .classic:
            return InterviewConfiguration(
                mode:.audio,
                maxQuestions: 3,
                maxAnswerDuration: 2,
                maxInterviewDuration: 20,
                silenceTimeout: 5
            )

        case let .custom(
            mode,
            maxQuestions,
            maxAnswerDuration,
            maxInterviewDuration
        ):
            return InterviewConfiguration(
                mode: mode,
                maxQuestions: maxQuestions,
                maxAnswerDuration: maxAnswerDuration,
                maxInterviewDuration: maxInterviewDuration,
                silenceTimeout: 5
            )
        }
    }
}


struct InterviewConfiguration: Equatable, Sendable {
    let mode: InterviewMode
    let maxQuestions: Int
    let maxAnswerDuration: TimeInterval
    let maxInterviewDuration: TimeInterval
    let silenceTimeout: TimeInterval
}
