import Foundation

protocol ResumeInterviewUseCaseProtocol {
    func execute(session: InterviewSession) async throws -> InterviewSession
}

final class ResumeInterviewUseCase: ResumeInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }

    func execute(session: InterviewSession) async throws -> InterviewSession {
        do {
            return try await repository.resumeInterview(session: session)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
