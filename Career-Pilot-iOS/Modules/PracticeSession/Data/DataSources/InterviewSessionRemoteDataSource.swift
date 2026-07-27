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
        print("startInterview:\(startInterviewEndPoint)")
        let result: NewSessionResponseDTO =  try await apiService.request(startInterviewEndPoint)
        print("Result: \(result)")
        return result.data
    }

    func submitAnswer(submitAnswerRequest: SubmitAnswerRequest) async throws -> SubmitAnswerResponseDTO {
<<<<<<< HEAD
        
=======
>>>>>>> 5743779d (Refactor: all the dto to make it confierm decodable not codable)
        print("submitAnswer: \(submitAnswerRequest)")
        let submitAnswerEndPoint = InterviewSessionEndPointes.submitAnswer(submitAnswerRequest.toDTO())
        let result: SubmitAnswerFinalResponseDTO = try await apiService.request(submitAnswerEndPoint)
        return result.data
    }

    func resumeInterview(sessionId: String) async throws -> SessionStateDTO {
        print("resumeInterview: \(sessionId)")

        let resumeEndPoint = InterviewSessionEndPointes.resumeSession(sessionId: sessionId)
        print("ResumeInterview: \(sessionId)")
        return try await apiService.request(resumeEndPoint)
    }

    func finishInterview(finishInterviewRequest: FinishInterviewRequest) async throws -> FeedbackReportDTO {
        print("FinshInterview: \(finishInterviewRequest)")
        let finishEndPoint = InterviewSessionEndPointes.getFeedback(sessionId: finishInterviewRequest.sessionID)
        return try await apiService.request(finishEndPoint)
    }

    func cancelInterview(sessionId: String) async throws {
    }
}
