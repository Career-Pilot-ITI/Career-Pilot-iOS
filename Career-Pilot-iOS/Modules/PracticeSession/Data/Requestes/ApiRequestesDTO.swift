//
//  ApiRequestes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 23/07/2026.
//

import Foundation

//MARK: StartInterviewSessionRequest
struct StartInterviewSessionRequestDTO: Encodable {
    let trackId: Int
    let questionCount: Int
    let durationMinutes: Int
}


//MARK: SubmitAnswerRequest
struct SubmitAnswerRequestDTO: Encodable {
    var sessionId: String
    var questionId: String
    var transcript: String?
    let sessionElapsedSeconds: Int?
    let durationMs: Int
    let audioAsUrl: URL
    let audioUrl: String
    let words: [WordTiming]?
}
struct WordTimingDTO: Encodable {
    let word: String
    let startMs: Int
    let endMs: Int
}

//MARK: FinishInterviewRequest
struct FinishInterviewRequestDTO{
    let sessionID: String
}


//MARK: Mappers
extension SubmitAnswerRequest{
    func toDTO() -> SubmitAnswerRequestDTO{
        return SubmitAnswerRequestDTO(sessionId: sessionId, questionId: questionId, sessionElapsedSeconds: sessionElapsedSeconds, durationMs: durationMs, audioAsUrl: audioAsUrl, audioUrl: audioUrl, words: words)
    }
}

extension StartInterviewSessionRequest{
    func toDTO() -> StartInterviewSessionRequestDTO{
        return StartInterviewSessionRequestDTO(trackId: trackId, questionCount: questionCount, durationMinutes: durationMinutes)
    }
}

extension FinishInterviewRequest{
    func toDTO() -> FinishInterviewRequestDTO{
        return FinishInterviewRequestDTO(sessionID: sessionID)
    }
}
