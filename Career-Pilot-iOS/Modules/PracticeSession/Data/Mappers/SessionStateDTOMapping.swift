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
            id: String(sessionId ?? 0),
            status: (status ?? "").mapStatusToDomain(),
            currentQuestionIndex: answeredCount ?? 0,
            questions: [],
            answers: [],
            configuration: configuration,
            currentQuestion: currentQuestion?.toDomain() ?? InterviewQuestion(id: "", text: "", order: 3),
            feedback: nil
        )
    }
}
