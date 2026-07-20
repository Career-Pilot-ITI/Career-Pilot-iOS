import Foundation

protocol StartInterviewUseCaseProtocol {
    func execute(configuration: InterviewConfiguration) async throws -> InterviewSession
}

final class StartInterviewUseCase: StartInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }

    func execute(configuration: InterviewConfiguration) async throws -> InterviewSession {
        do {
            return try await repository.startInterview(configuration: configuration)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
