//
//  InterviewsViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//

import Foundation
import SwiftUI

final class InterviewsViewModel : ObservableObject {
    
  @Published var searchText: String = ""

  @Published var interviewsMatchesYourSkills: [InterviewItem] = [
        InterviewItem(
            trackInterview: InterviewTrack(
                track: Track(
                    id: 1,
                    title: "System Design",
                    description: "Learn the fundamentals of designing scalable systems.",
                    isActive: true
                ),
                iconName: "waveform.path.ecg",
                iconColor: .gray600,
                iconBackground: .primaryTealLight,
                tag: "Matches: System Design",
                tagColor: .primaryTeal
            ),
            level: .mid
        ),

        InterviewItem(
            trackInterview: InterviewTrack(
                track: Track(
                    id: 2,
                    title: "React",
                    description: "Master React concepts, patterns, and best practices.",
                    isActive: true
                ),
                iconName: "bolt.fill",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: React",
                tagColor: .primary
            ),
            level: .mid
        ),

        InterviewItem(
            trackInterview: InterviewTrack(
                track: Track(
                    id: 3,
                    title: "AWS",
                    description: "Explore cloud architecture and AWS services.",
                    isActive: true
                ),
                iconName: "shield.fill",
                iconColor: .successColour,
                iconBackground: Color.successColour.opacity(0.15),
                tag: "Matches: AWS",
                tagColor: .successColour
            ),
            level: .senior
        ),

        InterviewItem(
            trackInterview: InterviewTrack(
                track: Track(
                    id: 4,
                    title: "TypeScript",
                    description: "Improve your TypeScript knowledge and design patterns.",
                    isActive: true
                ),
                iconName: "doc.text.fill",
                iconColor: .blue,
                iconBackground: Color.blue.opacity(0.12),
                tag: "Matches: TypeScript",
                tagColor: .blue
            ),
            level: .mid
        ),

        InterviewItem(
            trackInterview: InterviewTrack(
                track: Track(
                    id: 5,
                    title: "Behavioral",
                    description: "Prepare for behavioral interviews using proven techniques.",
                    isActive: true
                ),
                iconName: "star.fill",
                iconColor: .primaryYellow,
                iconBackground: Color.primaryYellow.opacity(0.2),
                tag: "Top Rated",
                tagColor: .activeColour
            ),
            level: .junior
        ),

        InterviewItem(
            trackInterview: InterviewTrack(
                track: Track(
                    id: 5,
                    title: "Behavioral",
                    description: "Practice leadership and soft-skills interview questions.",
                    isActive: true
                ),
                iconName: "rosette",
                iconColor: .purple,
                iconBackground: Color.purple.opacity(0.15),
                tag: "Popular · Soft Skills",
                tagColor: .purple
            ),
            level: .junior
        )
    ]
    
    
    var filteredInterviews: [InterviewItem] {
        guard !searchText.isEmpty else {
            return interviewsMatchesYourSkills
        }

        return interviewsMatchesYourSkills.filter { item in
            item.trackInterview.track.title
                .localizedCaseInsensitiveContains(searchText)
        }
    }
}
