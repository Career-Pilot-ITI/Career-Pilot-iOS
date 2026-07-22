//
//  InterviewRepositoryImp.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 21/07/2026.
//

import Foundation

final class InterviewRepositoryImp: InterviewRepository {

    private let remoteDataSource: InterviewSessionRemoteDataSource

    init(remoteDataSource: InterviewSessionRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func startInterview(startInterviewSessionRequest: StartInterviewSessionRequest) async throws -> InterviewSession {
        let sessionDTO = try await remoteDataSource.startInterview(startInterviewSessionRequest: startInterviewSessionRequest)
        return sessionDTO.toDomain(configuration: startInterviewSessionRequest.configuration)
    }

    func submitAnswer(submitAnswerRequest: SubmitAnswerRequest) async throws -> SubmitAnswerOutcome {
        
        let responseDTO = try await remoteDataSource.submitAnswer(submitAnswerRequest: submitAnswerRequest)

        // If the server handed back a next question, the session continues.
        if let nextQuestionDTO = responseDTO.nextQuestion {
            return .nextQuestion(nextQuestionDTO.toDomain())
        }

        let finishRequest = FinishInterviewRequest(sessionID: submitAnswerRequest.session.id)
        let feedbackDTO = try await remoteDataSource.finishInterview(finishInterviewRequest: finishRequest)
        return .interviewCompleted(feedbackDTO.toDomain())
    }

    func resumeInterview(session: InterviewSession) async throws -> InterviewSession {
        let sessionStateDTO = try await remoteDataSource.resumeInterview(sessionId: session.id)
        return sessionStateDTO.toDomain(configuration: session.configuration, questions: session
            .questions, answers: session.answers)
    }

    func finishInterview(finishInterviewRequest: FinishInterviewRequest) async throws -> InterviewFeedback {
        let feedbackDTO = try await remoteDataSource.finishInterview(finishInterviewRequest: finishInterviewRequest)
        return feedbackDTO.toDomain()
    }

    func cancelInterview(sessionId: String) async throws {
        try await remoteDataSource.cancelInterview(sessionId: sessionId)
    }
}
