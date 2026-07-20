import Foundation

struct InterviewQuestion: Equatable, Identifiable, Sendable {
    let id: String
    let text: String
    let order: Int
}
