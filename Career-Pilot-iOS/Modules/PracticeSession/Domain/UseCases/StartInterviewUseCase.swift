import Foundation


protocol StartInterviewUseCaseProtocol {
    func execute(startInterviewSessionRequest: StartInterviewSessionRequest) async throws -> NewSession
}

final class StartInterviewUseCase: StartInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }

    func execute(startInterviewSessionRequest: StartInterviewSessionRequest) async throws -> NewSession {
        do {
            return try await repository.startInterview(startInterviewSessionRequest: startInterviewSessionRequest)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
