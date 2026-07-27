import Foundation

enum InterviewType: Hashable{
    case Classic
    
    var interviewConfiguration: InterviewConfiguration{
        switch self{
        case.Classic:
            return InterviewConfiguration(maxQuestions: 3, maxAnswerDuration: TimeInterval(2), maxInterviewDuration: TimeInterval(120), silenceTimeout: TimeInterval(5))
        }
    }
}


struct InterviewConfiguration: Equatable, Sendable {
    let maxQuestions: Int
    let maxAnswerDuration: TimeInterval
    let maxInterviewDuration: TimeInterval
    let silenceTimeout: TimeInterval
}
