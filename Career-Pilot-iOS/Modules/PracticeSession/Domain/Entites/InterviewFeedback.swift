import Foundation

/// Wil be change depend on the screen info
struct InterviewFeedback: Equatable, Sendable {
    let overallScore: Double
    let communicationScore: Double
    let technicalScore: Double
    let strengths: [String]
    let weaknesses: [String]
    let recommendations: [String]
}
