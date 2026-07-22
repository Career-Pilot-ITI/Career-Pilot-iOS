//
//  InterviewQuestionMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension QuestionDTO {
    func toDomain() -> InterviewQuestion {
        InterviewQuestion(
            id: String(id),
            text: questionText,
            order: questionOrder
        )
    }
}
