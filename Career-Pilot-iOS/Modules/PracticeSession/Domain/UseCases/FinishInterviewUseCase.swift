import Foundation


protocol FinishInterviewUseCaseProtocol {
    func execute(finishInterviewRequest: FinishInterviewRequest) async throws -> InterviewFeedback
}

final class FinishInterviewUseCase: FinishInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }

    func execute(finishInterviewRequest: FinishInterviewRequest) async throws -> InterviewFeedback {
        do {
            return try await repository.finishInterview(finishInterviewRequest: finishInterviewRequest)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
