//
//  QuestionScoreDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation
import CoreData

extension QuestionScoreDTO {
    func toDomain() -> QuestionScore {
        QuestionScore(
            id: id,
            sessionQuestionId: sessionQuestionId,
            contentRelevance: contentRelevance,
            clarity: clarity,
            confidence: confidence,
            pacing: pacing,
            fillerWords: fillerWords,
            overallScore: overallScore,
            coachingTip: coachingTip,
            createdAt: createdAt
        )
    }

    func toEntity(in context: NSManagedObjectContext, question: SessionQuestionEntity) -> QuestionScoreEntity {
        let entity = QuestionScoreEntity(context: context)
        entity.id = Int64(id)
        entity.sessionQuestionId = Int64(sessionQuestionId)
        entity.contentRelevance = contentRelevance
        entity.clarity = clarity
        entity.confidence = confidence
        entity.pacing = pacing
        entity.fillerWords = fillerWords
        entity.overallScore = overallScore
        entity.coachingTip = coachingTip
        entity.createdAt = createdAt
        entity.question = question
        return entity
    }
}

extension QuestionScoreEntity {
    func toDTO() -> QuestionScoreDTO {
        QuestionScoreDTO(
            id: Int(id),
            sessionQuestionId: Int(sessionQuestionId),
            contentRelevance: contentRelevance,
            clarity: clarity,
            confidence: confidence,
            pacing: pacing,
            fillerWords: fillerWords,
            overallScore: overallScore,
            coachingTip: coachingTip ?? "",
            createdAt: createdAt ?? Date()
        )
    }
}
