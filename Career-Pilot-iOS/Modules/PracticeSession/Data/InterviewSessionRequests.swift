//
//  InterviewSessionRequests.swift
//  Career-Pilot-iOS
//

import Foundation



struct SubmitAnswerRequest: Encodable {
    let session: InterviewSession
    var transcript: String?
    let sessionElapsedSeconds: Int?
    let durationMs: Int
    let audioUrlAsString: String
    let audioUrl: URL
    let words: [WordTiming]?
}

struct WordTiming: Encodable {
    let word: String
    let startMs: Int
    let endMs: Int
}
