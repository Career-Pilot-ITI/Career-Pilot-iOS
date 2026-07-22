//
//  SessionDTOMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension NewSessionDTO {

    func toDomain(configuration: InterviewConfiguration? = nil) -> InterviewSession {
        let resolvedConfiguration = configuration ?? InterviewConfiguration(
            maxQuestions: maxQuestions,
            maxAnswerDuration: 240, // 4 min
            maxInterviewDuration: TimeInterval(targetDurationMinutes * 60),
            silenceTimeout: 5,
            trackID: 1 // TODO: map trackName -> trackID once tracks have stable server-side IDs
        )

        return InterviewSession(
            id: String(sessionId),
            status: .aiAsking,
            currentQuestionIndex: 0,
            questions: [currentQuestion.toDomain()],
            answers: [],
            configuration: resolvedConfiguration,
            feedback: nil
        )
    }
}
