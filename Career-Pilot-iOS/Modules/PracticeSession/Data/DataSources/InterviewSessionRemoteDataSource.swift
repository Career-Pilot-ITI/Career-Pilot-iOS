//
//  InterviewSessionRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

protocol InterviewSessionRemoteDataSource {
    func startInterview(configuration: InterviewConfiguration) async throws -> NewSessionDTO
    func submitAnswer(submitAnswerRequest: SubmitAnswerRequest) async throws -> SubmitAnswerResponseDTO
    func resumeInterview(sessionId: String) async throws -> SessionStateDTO
    func finishInterview(finishInterviewRequest: FinishInterviewRequest) async throws -> FeedbackReportDTO
    func cancelInterview(sessionId: String) async throws
}

class InterviewSessionRemoteDataSourceImp: InterviewSessionRemoteDataSource {
    var apiService: NetworkService

    init(apiService: NetworkService) {
        self.apiService = apiService
    }

    func startInterview(configuration: InterviewConfiguration) async throws -> NewSessionDTO {
        let startInterviewEndPoint = InterviewSessionEndPointes.startSession(configuration)
        return try await apiService.request(startInterviewEndPoint)
    }

    func submitAnswer(submitAnswerRequest: SubmitAnswerRequest) async throws -> SubmitAnswerResponseDTO {
        let submitAnswerEndPoint = InterviewSessionEndPointes.submitAnswer(submitAnswerRequest)
        return try await apiService.request(submitAnswerEndPoint)
    }

    func resumeInterview(sessionId: String) async throws -> SessionStateDTO {
        let resumeEndPoint = InterviewSessionEndPointes.resumeSession(sessionId: sessionId)
        return try await apiService.request(resumeEndPoint)
    }

    func finishInterview(finishInterviewRequest: FinishInterviewRequest) async throws -> FeedbackReportDTO {
        let finishEndPoint = InterviewSessionEndPointes.finishInterview(finishInterviewRequest)
        return try await apiService.request(finishEndPoint)
    }

    func cancelInterview(sessionId: String) async throws {
        let cancelEndPoint = InterviewSessionEndPointes.cancelSession(sessionId: sessionId)

        try await apiService.request(cancelEndPoint)
    }
}
