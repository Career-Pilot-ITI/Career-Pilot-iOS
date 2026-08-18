import Foundation


protocol StartInterviewUseCaseProtocol {
    func execute(interviewConfiguration: InterviewConfiguration,trackId: Int) async throws -> NewSession
}

final class StartInterviewUseCase: StartInterviewUseCaseProtocol {
    private let repository: InterviewRepository
    private let userLDS: UserLocalDataSource
    
    init(repository: InterviewRepository, userLDS: UserLocalDataSource) {
        self.repository = repository
        self.userLDS = userLDS
    }
    
    func execute(interviewConfiguration: InterviewConfiguration,trackId: Int) async throws -> NewSession {
        do {
            var startInterviewSessionRequest = StartInterviewSessionRequest(trackId: trackId, questionCount: interviewConfiguration.maxQuestions, durationMinutes: Int(interviewConfiguration.maxInterviewDuration))
            
            print("The Reeues was with trackId : \(startInterviewSessionRequest.trackId)")
            
            if startInterviewSessionRequest.trackId == 0 {
                startInterviewSessionRequest = StartInterviewSessionRequest(trackId: 5, questionCount: interviewConfiguration.maxQuestions, durationMinutes: Int(interviewConfiguration.maxInterviewDuration))
                print("So I convert it currntly to 5")
            }
            
            return try await repository.startInterview(startInterviewSessionRequest: startInterviewSessionRequest)
        } catch {
            throw InterviewError.map(error)
        }
    }
}
