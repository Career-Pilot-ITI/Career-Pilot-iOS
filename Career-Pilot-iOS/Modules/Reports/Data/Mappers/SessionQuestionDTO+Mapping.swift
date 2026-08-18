//
//  SessionQuestionDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation
import CoreData

extension SessionQuestionDTO {
    func toDomain() -> SessionQuestion {
        SessionQuestion(
            id: id,
            sessionId: sessionId,
            questionText: questionText,
            questionOrder: questionOrder,
            userTranscript: userTranscript,
            durationMs: durationMs,
            speechRateWpm: speechRateWpm,
            avgPauseMs: avgPauseMs,
            silenceRatio: silenceRatio,
            createdAt: createdAt,
            completedAt: completedAt,
            score: score?.toDomain()
        )
    }

    @discardableResult
    func toEntity(in context: NSManagedObjectContext, feedback: SessionFeedbackEntity) -> SessionQuestionEntity {
        let entity = SessionQuestionEntity(context: context)
        entity.id = Int64(id)
        entity.sessionId = Int64(sessionId)
        entity.questionText = questionText
        entity.questionOrder = Int64(questionOrder)
        entity.userTranscript = userTranscript ?? ""
        entity.durationMs = Int64(durationMs ?? 0)
        entity.speechRateWpm = speechRateWpm ?? 0
        entity.avgPauseMs = avgPauseMs ?? 0
        entity.silenceRatio = silenceRatio ?? 0
        entity.createdAt = createdAt
        entity.completedAt = completedAt
        entity.feedback = feedback
        if let score {
            entity.score = score.toEntity(in: context, question: entity)
        }
        return entity
    }
}

extension SessionQuestionEntity {
    func toDTO() -> SessionQuestionDTO {
        SessionQuestionDTO(
            id: Int(id),
            sessionId: Int(sessionId),
            questionText: questionText ?? "",
            questionOrder: Int(questionOrder),
            userTranscript: userTranscript ?? "",
            durationMs: Int(durationMs),
            speechRateWpm: speechRateWpm,
            avgPauseMs: avgPauseMs,
            silenceRatio: silenceRatio,
            createdAt: createdAt ?? Date(),
            completedAt: completedAt,
            score: score?.toDTO()
        )
    }
}
