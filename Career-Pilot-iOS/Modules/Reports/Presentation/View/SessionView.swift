//
//  SessionView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct SessionView: View {
    let metrics: [RadarMetric]
    let suggesions : [CoachingSuggestion]
    var body: some View {
        ZStack() {
            Color.lightBackGround.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.s16) {
                    PerformanceBreakdownView(metrics: metrics)
                    QuestionBreakDownView()
                    
                    VStack(alignment: .leading, spacing: Spacing.s12) {
                            Text("Coaching Suggestions")
                                .font(Font.size15Bold)
                                .foregroundStyle(Color.primaryNavy)

                            CoachingSuggestionsListView(suggestions: suggesions)
                        }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    SessionView(metrics: [
        RadarMetric(label: "Clarity", value: 78, color: .orange),
        RadarMetric(label: "Confidence", value: 85, color: .green),
        RadarMetric(label: "Pacing", value: 72, color: .orange),
        RadarMetric(label: "Filler Words", value: 65, color: .orange),
        RadarMetric(label: "Content", value: 90, color: .green)
    ],suggesions: [
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
