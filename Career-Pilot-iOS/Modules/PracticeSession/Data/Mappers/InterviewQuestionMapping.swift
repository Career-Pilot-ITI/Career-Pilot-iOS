//
//  InterviewQuestionMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension QuestionDTO {
    func toDomain() -> InterviewQuestion {
        InterviewQuestion(
            id: String(id ?? 0 ),
            text: questionText ?? "",
            order: questionOrder ?? 0
        )
    }
}
