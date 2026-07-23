//
//  NewSession.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 23/07/2026.
//

import Foundation

struct NewSession {
    let sessionId: Int
    let trackName: String
    let targetDurationMinutes: Int
    let maxQuestions: Int
    let startedAt: String
    let currentQuestion: InterviewQuestion
}

