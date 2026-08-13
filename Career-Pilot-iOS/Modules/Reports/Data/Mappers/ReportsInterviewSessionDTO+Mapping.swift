//
//  ReportsInterviewSessionDTO+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation
import CoreData

extension ReportsInterviewSessionDTO {
    func toDomain() -> ReportsInterviewSession {
        ReportsInterviewSession(
            id: id,
            trackId: trackId,
            trackName: trackName,
            status: SessionStatus(rawValue: status),
            overallScore: overallScore,
            durationSeconds: durationSeconds,
            targetDurationMinutes: targetDurationMinutes,
            maxQuestions: maxQuestions,
            startedAt: startedAt,
            completedAt: completedAt,
            createdAt: createdAt
        )
    }

    @discardableResult
    func toEntity(in context: NSManagedObjectContext, user: UserEntity) -> InterviewSessionEntity {
        let entity = InterviewSessionEntity(context: context)
        entity.id = Int64(id)
        entity.trackId = Int64(trackId)
        entity.trackName = trackName
        entity.status = status
        entity.overallScore = overallScore ?? 0
        entity.durationSeconds = Int64(durationSeconds ?? 0)
        entity.targetDurationMinutes = Int64(targetDurationMinutes)
        entity.maxQuestions = Int64(maxQuestions)
        entity.startedAt = startedAt
        entity.completedAt = completedAt
        entity.createdAt = createdAt
        entity.user = user
        return entity
    }
}

extension InterviewSessionEntity {
    func toDTO() -> ReportsInterviewSessionDTO {
        ReportsInterviewSessionDTO(
            id: Int(id),
            trackId: Int(trackId),
            trackName: trackName ?? "",
            status: status ?? "",
            overallScore: overallScore,
            durationSeconds: Int(durationSeconds),
            targetDurationMinutes: Int(targetDurationMinutes),
            maxQuestions: Int(maxQuestions),
            startedAt: startedAt,
            completedAt: completedAt,
            createdAt: createdAt ?? Date()
        )
    }
}
