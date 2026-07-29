import Foundation

enum InterviewType: Hashable {
    case classic
    case custom(
        maxQuestions: Int,
        maxAnswerDuration: TimeInterval,
        maxInterviewDuration: TimeInterval
    )

    var interviewConfiguration: InterviewConfiguration {
        switch self {
        case .classic:
            return InterviewConfiguration(
                maxQuestions: 3,
                maxAnswerDuration: 2,
                maxInterviewDuration: 120,
                silenceTimeout: 5
            )

        case let .custom(
            maxQuestions,
            maxAnswerDuration,
            maxInterviewDuration
        ):
            return InterviewConfiguration(
                maxQuestions: maxQuestions,
                maxAnswerDuration: maxAnswerDuration,
                maxInterviewDuration: maxInterviewDuration,
                silenceTimeout: 5
            )
        }
    }
}


struct InterviewConfiguration: Equatable, Sendable {
    let maxQuestions: Int
    let maxAnswerDuration: TimeInterval
    let maxInterviewDuration: TimeInterval
    let silenceTimeout: TimeInterval
}
