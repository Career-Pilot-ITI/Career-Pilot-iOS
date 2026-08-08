import Foundation

struct InterviewFeedback: Equatable, Sendable {
    let overallScore: Int
    let clarityScore: Int
    let confidenceScore: Int
    let pacingScore: Int
    let fillerWordsScore: Int
    let contentRelevanceScore: Int
    let coachingTips: [String]
    let questions: [InterviewFeedbackQuestion]
    
    static var empty: InterviewFeedback {
        InterviewFeedback(
            overallScore: 0,
            clarityScore: 0,
            confidenceScore: 0,
            pacingScore: 0,
            fillerWordsScore: 0,
            contentRelevanceScore: 0,
            coachingTips: [],
            questions: []
        )
    }
}

struct InterviewFeedbackQuestion: Equatable, Sendable {
    let question: String
    let transcript: String
    let durationMs: Int
    let speechRateWpm: Int
    let silenceRatio: Double
    let score: InterviewQuestionScore
    
    static var empty: InterviewFeedbackQuestion {
        InterviewFeedbackQuestion(
            question: "",
            transcript: "",
            durationMs: 0,
            speechRateWpm: 0,
            silenceRatio: 0.0,
            score: .empty
        )
    }
}

struct InterviewQuestionScore: Equatable, Sendable {
    let overall: Int
    let clarity: Int
    let confidence: Int
    let pacing: Int
    let fillerWords: Int
    let contentRelevance: Int
    let coachingTip: String
    
    static var empty: InterviewQuestionScore {
        InterviewQuestionScore(
            overall: 0,
            clarity: 0,
            confidence: 0,
            pacing: 0,
            fillerWords: 0,
            contentRelevance: 0,
            coachingTip: ""
        )
    }
}
