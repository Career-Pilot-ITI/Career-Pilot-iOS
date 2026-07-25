import Foundation


protocol StartInterviewUseCaseProtocol {
    func execute(interviewConfiguration: InterviewConfiguration) async throws -> NewSession
}

final class StartInterviewUseCase: StartInterviewUseCaseProtocol {
    private let repository: InterviewRepository
    private let userLDS: UserLocalDataSource

    init(repository: InterviewRepository, userLDS: UserLocalDataSource) {
        self.repository = repository
        self.userLDS = userLDS
    }

    func execute(interviewConfiguration: InterviewConfiguration) async throws -> NewSession {
        do {
            // Need to get trackId
            let user = try await userLDS.getUser()
            guard let user = user else{
                throw InterviewError.invalidState(current: .aiAsking, attempted: "User Not Found")
            }
            let trackId = user.profile.trackId
            
            
            let startInterviewSessionRequest = StartInterviewSessionRequest(trackId: trackId, questionCount: Int(interviewConfiguration.maxInterviewDuration), durationMinutes: Int(interviewConfiguration.maxInterviewDuration))
            
            return try await repository.startInterview(startInterviewSessionRequest: startInterviewSessionRequest)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
