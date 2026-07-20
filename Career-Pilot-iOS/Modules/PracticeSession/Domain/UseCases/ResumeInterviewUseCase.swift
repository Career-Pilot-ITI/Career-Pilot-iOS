import Foundation

protocol ResumeInterviewUseCaseProtocol {
    func execute(sessionId: String) async throws -> InterviewSession
}

final class ResumeInterviewUseCase: ResumeInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }

    func execute(sessionId: String) async throws -> InterviewSession {
        do {
            return try await repository.resumeInterview(sessionId: sessionId)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
