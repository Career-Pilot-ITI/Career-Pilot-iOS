import Foundation

struct InterviewFeedback: Equatable,Sendable {
    let overallScore: Int
    let clarityScore: Int
    let confidenceScore: Int
    let pacingScore: Int
    let fillerWordsScore: Int
    let contentRelevanceScore: Int
    let coachingTips: [String]
    let questions: [InterviewFeedbackQuestion]
}

struct InterviewFeedbackQuestion: Equatable,Sendable {
    let question: String
    let transcript: String
    let durationMs: Int
    let speechRateWpm: Int
    let silenceRatio: Double
    let score: InterviewQuestionScore
}

struct InterviewQuestionScore: Equatable,Sendable {
    let overall: Int
    let clarity: Int
    let confidence: Int
    let pacing: Int
    let fillerWords: Int
    let contentRelevance: Int
    let coachingTip: String
}
