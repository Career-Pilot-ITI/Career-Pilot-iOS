//
//  ApiRequestes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 22/07/2026.
//

import Foundation

//MARK: StartInterviewSessionRequest
struct StartInterviewSessionRequest: Encodable {
    let trackId: Int
    let questionCount: Int
    let durationMinutes: Int
}


//MARK: SubmitAnswerRequest
struct SubmitAnswerRequest: Encodable {
    var sessionId: String
    var questionId: String
    var transcript: String?
    let sessionElapsedSeconds: Int?
    let durationMs: Int
    var audioAsUrl: URL
    var audioUrl: String
    let words: [WordTiming]?
}
struct WordTiming: Encodable {
    let word: String
    let startMs: Int
    let endMs: Int
}

//MARK: FinishInterviewRequest
struct FinishInterviewRequest{
    let sessionID: String
}
