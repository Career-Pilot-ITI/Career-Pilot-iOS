//
//  InterviewSessionDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

struct ReportsInterviewSessionDTO: Codable {
    let id: Int
    let trackId: Int
    let trackName: String
    let status: String
    let overallScore: Double
    let durationSeconds: Int
    let targetDurationMinutes: Int
    let maxQuestions: Int
    let startedAt: Date?
    let completedAt: Date?
    let createdAt: Date
}

// ReportsInterviewSessionResponseDTO was removed.
// Sessions are now delivered inside PageResponse<ReportsInterviewSessionDTO>
// by the backend's Spring Data page envelope.
// See: Core/Data/Network/DTOs/PageResponse.swift
