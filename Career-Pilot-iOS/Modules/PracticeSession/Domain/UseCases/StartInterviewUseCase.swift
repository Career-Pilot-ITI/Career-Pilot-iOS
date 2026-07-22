import Foundation

struct StartInterviewSessionRequest: Encodable {
    let trackId: Int
    let questionCount: Int
    let durationMinutes: Int
    let configuration: InterviewConfiguration
}

protocol StartInterviewUseCaseProtocol {
    func execute(startInterviewSessionRequest: StartInterviewSessionRequest) async throws -> InterviewSession
}

final class StartInterviewUseCase: StartInterviewUseCaseProtocol {
    private let repository: InterviewRepository

    init(repository: InterviewRepository) {
        self.repository = repository
    }

    func execute(startInterviewSessionRequest: StartInterviewSessionRequest) async throws -> InterviewSession {
        do {
            return try await repository.startInterview(startInterviewSessionRequest: startInterviewSessionRequest)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
