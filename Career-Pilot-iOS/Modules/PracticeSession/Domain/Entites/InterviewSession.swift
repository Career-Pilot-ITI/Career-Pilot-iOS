import Foundation

struct InterviewSession: Equatable, Sendable {
    let id: String
    var status: InterviewSessionStatus
    var currentQuestionIndex: Int
    var questions: [InterviewQuestion]
    var answers: [InterviewAnswer]
    let configuration: InterviewConfiguration
    var feedback: InterviewFeedback?

    var currentQuestion: InterviewQuestion? {
        guard questions.indices.contains(currentQuestionIndex) else { return nil }
        return questions[currentQuestionIndex]
    }
}


//MARK: InterviewAnswer
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


//MARK: InterviewQuestion
struct InterviewQuestion: Equatable, Identifiable, Sendable {
    let id: String
    let text: String
    let order: Int
    
}

