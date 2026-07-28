//
//  SessionFeedbackDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation
import CoreData

extension SessionFeedbackDTO {
    @discardableResult
    func toEntity(in context: NSManagedObjectContext, session: InterviewSessionEntity) -> SessionFeedbackEntity {
        let entity = SessionFeedbackEntity(context: context)
        entity.id = Int64(id)
        entity.sessionId = Int64(sessionId)
        entity.overallScore = overallScore
        entity.clarityScore = clarityScore
        entity.confidenceScore = confidenceScore
        entity.pacingScore = pacingScore
        entity.fillerWordsScore = fillerWordsScore
        entity.contentRelevanceScore = contentRelevanceScore
        entity.coachingTips = coachingTips
        entity.generatedAt = generatedAt
        entity.createdAt = createdAt
        entity.session = session

        let questionEntities = questions.map { $0.toEntity(in: context, feedback: entity) }
        entity.questions = NSSet(array: questionEntities)
        return entity
    }
}

extension SessionFeedbackEntity {
    func toDTO() -> SessionFeedbackDTO {
        let questionEntities = (questions as? Set<SessionQuestionEntity>) ?? []
        let sortedQuestions = questionEntities
            .sorted { $0.questionOrder < $1.questionOrder }
            .map { $0.toDTO() }
        return SessionFeedbackDTO(
            id: Int(id),
            sessionId: Int(sessionId),
            overallScore: overallScore,
            clarityScore: clarityScore,
            confidenceScore: confidenceScore,
            pacingScore: pacingScore,
            fillerWordsScore: fillerWordsScore,
            contentRelevanceScore: contentRelevanceScore,
            coachingTips: (coachingTips) ?? [],
            generatedAt: generatedAt ?? Date(),
            createdAt: createdAt ?? Date(),
            questions: sortedQuestions
        )
    }
}
