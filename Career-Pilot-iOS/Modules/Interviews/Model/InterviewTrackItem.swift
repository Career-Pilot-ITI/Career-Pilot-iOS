//
//  InterviewTrackItem.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//

import SwiftUI

enum InterviewLevel: String {
    case junior = "Junior"
    case mid = "Mid"
    case senior = "Senior"
    
    var duration: Int {
        switch self {
        case .junior: return 20
        case .mid: return 40
        case .senior: return 60
        }
    }
    
    var levelColor : Color {
        switch self {
        case .junior :
            return .successColour
        case .mid :
            return .activeColour
        case .senior :
            return .errorColour
        }
    }
    
    var durationText: String {
        "~\(duration) min"
    }
}

struct InterviewTrack {
    let track: Track
    let iconName: String
    let iconColor: Color
    let iconBackground: Color
    let tag: String?            
    let tagColor: Color
}


struct InterviewItem: Identifiable {
    let id = UUID()
    let trackInterview : InterviewTrack
    let level: InterviewLevel
}
