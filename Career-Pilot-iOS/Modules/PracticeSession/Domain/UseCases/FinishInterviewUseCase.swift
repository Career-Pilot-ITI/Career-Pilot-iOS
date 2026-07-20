import Foundation

protocol FinishInterviewUseCaseProtocol {
    func execute(sessionId: String) async throws -> InterviewFeedback
}

final class FinishInterviewUseCase: FinishInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }

    func execute(sessionId: String) async throws -> InterviewFeedback {
        do {
            return try await repository.finishInterview(sessionId: sessionId)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
