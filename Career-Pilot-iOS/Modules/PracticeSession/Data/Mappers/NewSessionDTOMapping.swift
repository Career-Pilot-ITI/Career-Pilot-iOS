//
//  NewSessionDTOMapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 23/07/2026.
//

import Foundation

extension NewSessionDTO{
    func toDomain() -> NewSession{
        return NewSession(sessionId: sessionId ?? 0, trackName: trackName ?? "", targetDurationMinutes: targetDurationMinutes ?? 0, maxQuestions: maxQuestions ?? 0, startedAt: (startedAt ?? "").toDate() ?? Date(),
                          currentQuestion: currentQuestion?.toDomain() ?? InterviewQuestion(id: "", text: "", order: 0) )
    }
}
