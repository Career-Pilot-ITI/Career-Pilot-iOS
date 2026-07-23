//
//  NewSessionDTOMapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 23/07/2026.
//

import Foundation

extension NewSessionDTO{
    func toDomain() -> NewSession{
        return NewSession(sessionId: sessionId, trackName: trackName, targetDurationMinutes: targetDurationMinutes, maxQuestions: maxQuestions, startedAt: startedAt.toDate() ?? Date(), currentQuestion: currentQuestion.toDomain())
    }
}
