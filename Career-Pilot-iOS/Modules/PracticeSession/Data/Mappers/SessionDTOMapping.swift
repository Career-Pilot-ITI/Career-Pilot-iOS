//
//  SessionDTOMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension NewSessionDTO {

    func toDomain(configuration: InterviewConfiguration) -> InterviewSession {
        return InterviewSession(
            id: String(sessionId ?? 0),
            status: .aiAsking,
            currentQuestionIndex: 0,
            questions: [(currentQuestion ?? QuestionDTO(id: 0, sessionId: 0, questionText: "", questionOrder: 0, createdAt: "")).toDomain()],
            answers: [],
            configuration: configuration,
            currentQuestion: (currentQuestion ?? QuestionDTO(id: 0, sessionId: 0, questionText: "", questionOrder: 0, createdAt: "")).toDomain(),
            feedback: nil
        )
    }
}
