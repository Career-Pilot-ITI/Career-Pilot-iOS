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
            
            let tokenProvieder: TokenProviding = AuthTokenProvider(tokenStore: KeychainAuthTokenStore())
            
            print("Token: \(try await tokenProvieder.getAccessToken())")
            
            // Need to get trackId
            let user = try await userLDS.getUser()

//            let trackId = user?.profile.trackId
            let trackId = 5

            let startInterviewSessionRequest = StartInterviewSessionRequest(trackId: trackId, questionCount: interviewConfiguration.maxQuestions, durationMinutes: Int(interviewConfiguration.maxInterviewDuration))
            
            return try await repository.startInterview(startInterviewSessionRequest: startInterviewSessionRequest)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
