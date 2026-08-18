//
//  SessionView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//

import SwiftUI

struct SessionView: View {
    @StateObject private var viewModel: SessionDetailViewModel
    let sessionId: Int
    var onBreakdownTap: (() -> Void)? = nil

    init(sessionId: Int, viewModel: SessionDetailViewModel, onBreakdownTap: (() -> Void)? = nil) {
        self.sessionId = sessionId
        self.onBreakdownTap = onBreakdownTap
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            switch viewModel.state {
            case .idle, .loading:
                SessionFeedbackSkeletonView()
            case .error(let message):
                Text(message).foregroundStyle(.red)
            case .loaded:
                if let feedback = viewModel.feedback {
                    SessionFeedBackView(
                        feedback: feedback.toInterviewFeedback(),
                        sessionId: sessionId,
                        onBreakdownTap: onBreakdownTap
                    )
                }
            }
        }
        .toolbar(.hidden,for: .tabBar)
        .task {
            await viewModel.loadFeedback()
        }
    }
}

private struct SessionFeedbackSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.s16) {
                SkeletonBlock(height: 116)
                SkeletonBlock(height: 390)
                SkeletonBlock(height: 56)
                VStack(alignment: .leading, spacing: Spacing.s12) {
                    SkeletonPill(width: 150, height: 16)
                    SkeletonBlock(height: 96)
                    SkeletonBlock(height: 96)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
    }
}


struct SessionFeedBackView: View {
    var feedback: InterviewFeedback
    var sessionId: Int
    var onBack: (() -> Void)? = nil
    var onBreakdownTap: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: Spacing.s16) {
                    OverallScoreCardView(
                        score: Int(feedback.overallScore),
                        performanceLabel: performanceLabel(for: Double(feedback.overallScore)),
                        percentileText: "Top 28% of users this week"
                    )
                    PerformanceBreakdownView(metrics: feedback.toRadarMetrics())
                    QuestionBreakDownView(sessionId: sessionId, onTap: onBreakdownTap)
                    VStack(alignment: .leading, spacing: Spacing.s12) {
                        HStack {
                            Text("Coaching Suggestions")
                                .font(Font.size15Bold)
                            
                            Spacer()
                        }
                        CoachingSuggestionsListView(suggestions: feedback.toCoachingSuggestions())
                    }
                }
                .padding(.top, 16)
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        
    }
    
    
    func performanceLabel(for score: Double) -> String {
        switch score {
        case 85...: return "Strong Performance"
        case 65..<85: return "Good Performance"
        default: return "Needs Improvement"
        }
    }
}

//
//#Preview {
//    SessionView(metrics: [
//        RadarMetric(label: "Clarity", value: 78, color: .orange),
//        RadarMetric(label: "Confidence", value: 85, color: .green),
//        RadarMetric(label: "Pacing", value: 72, color: .orange),
//        RadarMetric(label: "Filler Words", value: 65, color: .orange),
//        RadarMetric(label: "Content", value: 90, color: .green)
//    ],suggesions: [
//        CoachingSuggestion(
//            icon: "target",
//            text: "Reduce filler words",
//            description: "You used 'um' and 'uh' 14 times. Try pausing silently instead.",
//            badgeLevel: "High impact"
//        ),
//        CoachingSuggestion(
//            icon: "target",
//            text: "Slow down your pace",
//            description: "Your speaking pace was a bit fast in the second half of the answer.",
//            badgeLevel: "Medium impact"
//        ),
//        CoachingSuggestion(
//            icon: "target",
//            text: "Add more structure",
//            description: "Try using a clear beginning, middle, and end for your answers.",
//            badgeLevel: "Low impact"
//        )
//    ])
//}
