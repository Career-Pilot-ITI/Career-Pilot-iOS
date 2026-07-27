//
//  InterviewSessionRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

protocol InterviewSessionRemoteDataSource {
    func startInterview(startInterviewSessionRequest: StartInterviewSessionRequest) async throws -> NewSessionDTO
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

    func startInterview(startInterviewSessionRequest: StartInterviewSessionRequest) async throws -> NewSessionDTO {
        let startInterviewEndPoint = InterviewSessionEndPointes.startSession(startInterviewSessionRequest.toDTO())
        print("startInterviewRDS:\(startInterviewEndPoint)")
        let result: NetworkResponseDTO<NewSessionDTO> =  try await apiService.request(startInterviewEndPoint)
        print("Result: \(result)")
        return result.data
    }

    func submitAnswer(submitAnswerRequest: SubmitAnswerRequest) async throws -> SubmitAnswerResponseDTO {
        print("submitAnswerRDS: \(submitAnswerRequest)")
        let submitAnswerEndPoint = InterviewSessionEndPointes.submitAnswer(submitAnswerRequest.toDTO())
        let result: NetworkResponseDTO<SubmitAnswerResponseDTO> = try await apiService.request(submitAnswerEndPoint)
        print("Result: \(result)")
        return result.data
    }

    func resumeInterview(sessionId: String) async throws -> SessionStateDTO {
        print("resumeInterviewRDS: \(sessionId)")

        let resumeEndPoint = InterviewSessionEndPointes.resumeSession(sessionId: sessionId)
        let result: NetworkResponseDTO<SessionStateDTO> = try await apiService.request(resumeEndPoint)
        print("Result: \(result)")
        return result.data
    }

    func finishInterview(finishInterviewRequest: FinishInterviewRequest) async throws -> FeedbackReportDTO {
        print("FinshInterviewRDS: \(finishInterviewRequest)")
        let finishEndPoint = InterviewSessionEndPointes.getFeedback(sessionId: finishInterviewRequest.sessionID)
        let result: NetworkResponseDTO<FeedbackReportDTO> = try await apiService.request(finishEndPoint)
        print("Result: \(result)")
        return result.data
    }

    func cancelInterview(sessionId: String) async throws {
    }
}
