//
//  InterviewQuestionMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension Question {
    func toDomain() -> InterviewQuestion {
        InterviewQuestion(
            id: String(id),
            text: questionText,
            order: questionOrder
        )
    }
}

extension NextQuestionDTO {
    func toDomain() -> InterviewQuestion {
        InterviewQuestion(
            id: String(id),
            text: questionText,
            order: questionOrder
        )
    }
}
