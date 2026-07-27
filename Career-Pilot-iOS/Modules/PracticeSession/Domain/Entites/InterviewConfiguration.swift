import Foundation

enum InterviewType: Hashable{
    case Classic
    
    var interviewConfiguration: InterviewConfiguration{
        switch self{
        case.Classic:
            return InterviewConfiguration(maxQuestions: 5, maxAnswerDuration: TimeInterval(120), maxInterviewDuration: TimeInterval(1200), silenceTimeout: TimeInterval(5))
        }
    }
}


struct InterviewConfiguration: Equatable, Sendable {
    let maxQuestions: Int
    let maxAnswerDuration: TimeInterval
    let maxInterviewDuration: TimeInterval
    let silenceTimeout: TimeInterval
}
