//
//  StringMapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 23/07/2026.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        return formatter.date(from: self)
    }
}


extension String {

    func mapStatusToDomain() -> InterviewSessionStatus {
        switch self.lowercased() {
        case "pending":
            return .paused

        case "inprogress":
            return .recording

        case "completed":
            return .completed

        default:
            return .completed
        }
    }
}
