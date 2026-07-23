import Foundation

protocol CancelInterviewUseCaseProtocol {
    func execute(sessionId: String) async throws
}

final class CancelInterviewUseCase: CancelInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }


    func execute(sessionId: String) async throws {
        do {
            try await repository.cancelInterview(sessionId: sessionId)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
