import Foundation

protocol ReportsRemoteDataSourceProtocol {
    func fetchSessions(page: Int, size: Int) async throws -> PageResponse<ReportsInterviewSessionDTO>
    func fetchSessionDetail(sessionId: Int) async throws -> ReportsInterviewSessionDTO
    func fetchSessionQuestions(sessionId: Int) async throws -> [SessionQuestionDTO]
    func fetchQuestionDetail(sessionId: Int, questionId: Int) async throws -> SessionQuestionDTO
    func fetchSessionFeedback(sessionId: Int) async throws -> SessionFeedbackDTO
}

final class ReportsRemoteDataSource: ReportsRemoteDataSourceProtocol {
    private let network: NetworkService

    init(network: NetworkService) {
        self.network = network
    }

    func fetchSessions(page: Int, size: Int) async throws -> PageResponse<ReportsInterviewSessionDTO> {
        let response: NetworkResponseDTO<PageResponse<ReportsInterviewSessionDTO>> =
            try await network.request(ReportsEndpoint.sessions(page: page, size: size))
        return response.data
    }

    func fetchSessionDetail(sessionId: Int) async throws -> ReportsInterviewSessionDTO {
        let response: NetworkResponseDTO<ReportsInterviewSessionDTO> =
            try await network.request(ReportsEndpoint.sessionDetail(sessionId: sessionId))
        return response.data
    }

    func fetchSessionQuestions(sessionId: Int) async throws -> [SessionQuestionDTO] {
        let response: NetworkResponseDTO<[SessionQuestionDTO]> =
            try await network.request(ReportsEndpoint.sessionQuestions(sessionId: sessionId))
        return response.data
    }

    func fetchQuestionDetail(sessionId: Int, questionId: Int) async throws -> SessionQuestionDTO {
        let response: NetworkResponseDTO<SessionQuestionDTO> =
            try await network.request(ReportsEndpoint.questionDetail(sessionId: sessionId, questionId: questionId))
        return response.data
    }

    func fetchSessionFeedback(sessionId: Int) async throws -> SessionFeedbackDTO {
        let response: NetworkResponseDTO<SessionFeedbackDTO> =
            try await network.request(ReportsEndpoint.sessionFeedback(sessionId: sessionId))
        return response.data
    }
}
