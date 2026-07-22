//
//  SessionDTOMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension NewSessionDTO {

    func toDomain(configuration: InterviewConfiguration) -> InterviewSession {
        return InterviewSession(
            id: String(sessionId),
            status: .aiAsking,
            currentQuestionIndex: 0,
            questions: [currentQuestion.toDomain()],
            answers: [],
            configuration: configuration,
            currentQuestion: currentQuestion.toDomain(),
            feedback: nil
        )
    }
}
