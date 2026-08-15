//
//  Track.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import Foundation

struct Track: Identifiable {
    let id : Int
    let title: String
    let description: String
    let isActive: Bool
}

extension Track {
    func toInterviewItem() -> InterviewItem {
        let level = InterviewLevel.inferLevel(from: self.title)
        let trackInterview = InterviewTrack.makeTrack(from: self)
        
        return InterviewItem(
            trackInterview: trackInterview,
            level: level
        )
    }
}
