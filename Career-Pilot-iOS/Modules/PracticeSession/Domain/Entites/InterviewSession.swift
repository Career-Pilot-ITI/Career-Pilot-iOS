import Foundation

struct InterviewSession: Equatable, Sendable {
    var id: String
    var status: InterviewSessionStatus
    var currentQuestionIndex: Int
    var questions: [InterviewQuestion]
    var answers: [InterviewAnswer]
    var configuration: InterviewConfiguration
    var currentQuestion: InterviewQuestion
    var feedback: InterviewFeedback?
    
    var currentQuestionFromStoredArrat: InterviewQuestion? {
        guard questions.indices.contains(currentQuestionIndex) else { return nil }
        return questions[currentQuestionIndex]
    }
}


//MARK: InterviewAnswer
enum SubmitAnswerOutcome: Equatable, Sendable {
    case nextQuestion(InterviewQuestion)
    case interviewCompleted(InterviewFeedback)
}

//enum AudioReference: Equatable, Sendable, Encodable {
//    case localFile(URL)
//    case remoteURL(URL)
//}

struct InterviewAnswer: Equatable, Sendable{
    let questionId: String
    let audioURL: URL
    let duration: TimeInterval
    let submittedAt: Date
}


//MARK: InterviewQuestion
struct InterviewQuestion: Equatable, Identifiable, Sendable{
    let id: String
    let text: String
    let order: Int
    
}

