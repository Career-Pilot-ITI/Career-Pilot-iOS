//
//  SessionStateDTOMapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 22/07/2026.
//

import Foundation

extension SessionStateDTO {

    func toDomain(configuration: InterviewConfiguration) -> InterviewSession {

        InterviewSession(
            id: String(sessionId),
            status: status.mapStatusToDomain(),
            currentQuestionIndex: answeredCount,
            questions: [],
            answers: [],
            configuration: configuration,
            currentQuestion: currentQuestion?.toDomain() ?? InterviewQuestion(id: "", text: "", order: 3),
            feedback: nil
        )
    }
}

extension String {

    func mapStatusToDomain() -> InterviewSessionStatus {
        switch self.lowercased() {
        case "pending":
            return .paused

        case "inprogress":
            return .recording

        case "completed":
            return .completed

        default:
            return .completed
        }
    }
}
