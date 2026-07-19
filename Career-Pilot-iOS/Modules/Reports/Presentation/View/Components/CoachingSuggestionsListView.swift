//
//  CoachingSuggestionsListView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct CoachingSuggestion: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let description: String
    let badgeLevel: String
}

struct CoachingSuggestionsListView: View {
    let suggestions: [CoachingSuggestion]

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.s12) {
                ForEach(suggestions) { suggestion in
                    CoachingSuggestionItemView(suggestion: suggestion)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.lightBackGround)
    }
}

#Preview {
    CoachingSuggestionsListView(suggestions: [
        CoachingSuggestion(
            icon: "target",
            text: "Reduce filler words",
            description: "You used 'um' and 'uh' 14 times. Try pausing silently instead.",
            badgeLevel: "High impact"
        ),
        CoachingSuggestion(
            icon: "target",
            text: "Slow down your pace",
            description: "Your speaking pace was a bit fast in the second half of the answer.",
            badgeLevel: "Medium impact"
        ),
        CoachingSuggestion(
            icon: "target",
            text: "Add more structure",
            description: "Try using a clear beginning, middle, and end for your answers.",
            badgeLevel: "Low impact"
        )
    ])
}
