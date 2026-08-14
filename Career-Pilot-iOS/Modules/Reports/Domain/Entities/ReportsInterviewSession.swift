//
//  InterviewSession.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

struct ReportsInterviewSession: Equatable, Identifiable {
    let id: Int
    let trackId: Int
    let trackName: String
    let status: SessionStatus
    let overallScore: Double?
    let durationSeconds: Int?
    let targetDurationMinutes: Int
    let maxQuestions: Int
    let startedAt: Date?
    let completedAt: Date?
    let createdAt: Date
}

enum SessionStatus: Equatable {
    case inProgress
    case completed
    case abandoned
    case unknown(String)

    init(rawValue: String) {
        switch rawValue.lowercased() {
            case "in_progress", "inprogress":
                self = .inProgress
            case "completed":
                self = .completed
            case "abandoned":
                self = .abandoned
            default:
                self = .unknown(rawValue)
        }
    }

    var rawValue: String {
        switch self {
        case .inProgress: return "in_progress"
        case .completed: return "completed"
        case .abandoned: return "abandoned"
        case .unknown(let value): return value
        }
    }

    var displayName: String {
        switch self {
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .abandoned: return "Abandoned"
        case .unknown(let value): return value.capitalized
        }
    }
}
