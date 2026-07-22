//
//  SessionStateDTOMapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 22/07/2026.
//

import Foundation

extension SessionStateDTO {

    func toDomain(
        configuration: InterviewConfiguration,
        questions: [InterviewQuestion],
        answers: [InterviewAnswer]
    ) -> InterviewSession {

        InterviewSession(
            id: String(sessionId),
            status: status.toDomain(),
            currentQuestionIndex: answeredCount,
            questions: questions,
            answers: answers,
            configuration: configuration,
            feedback: nil
        )
    }
}

extension String {

    func toDomain() -> InterviewSessionStatus {
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
