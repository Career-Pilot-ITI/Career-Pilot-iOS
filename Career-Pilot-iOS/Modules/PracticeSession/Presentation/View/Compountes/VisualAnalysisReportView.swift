//
//  VisualAnalysisReportView.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 14/08/2026.
//

import SwiftUI

struct VisualAnalysisReportView: View {
    let score: InterviewPresenceScore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.s24) {
                    OverallScoreHeader(score: score.overallScore)

                    VStack(spacing: Spacing.s12) {
                        MetricCard(
                            icon: "eye.fill",
                            title: "Eye Contact",
                            score: score.eyeContact.score,
                            detail: "\(Int(score.eyeContact.ratio * 100))% of visible time looking at camera"
                        )

                        MetricCard(
                            icon: "figure.stand",
                            title: "Posture",
                            score: score.posture.score,
                            detail: "Stability \(score.posture.stabilityScore)%"
                        )

                        MetricCard(
                            icon: "arrow.left.arrow.right",
                            title: "Head Movement",
                            score: score.headMovement.score,
                            detail: "\(score.headMovement.lookingAwayEventCount) looking-away events"
                        )

                        MetricCard(
                            icon: "hand.raised.fill",
                            title: "Hand Movement",
                            score: score.handMovement.score,
                            detail: handMovementDetail
                        )

                        MetricCard(
                            icon: "figure.walk",
                            title: "Body Movement",
                            score: score.bodyMovement.score,
                            detail: "\(score.bodyMovement.excessiveMovementEventCount) excessive movement events"
                        )

                        FaceVisibilityRow(metrics: score.faceVisibility)
                    }

                    DisclaimerNote()
                }
                .padding(Spacing.s20)
            }
            .background(Color.darkBackGround.ignoresSafeArea())
            .navigationTitle("Body Language Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.gray100)
                }
            }
        }
    }

    private var handMovementDetail: String {
        if score.handMovement.inactivityRatio > 0.85 {
            return "Hands were mostly still"
        }
        return String(format: "%.0f movements/min", score.handMovement.movementFrequencyPerMinute)
    }
}

// MARK: - Subviews

private struct OverallScoreHeader: View {
    let score: Int

    var body: some View {
        VStack(spacing: Spacing.s8) {
            ZStack {
                Circle()
                    .stroke(Color.gray600.opacity(0.3), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 0) {
                    Text("\(score)")
                        .font(.size26Semibold)
                        .foregroundStyle(Color.gray100)
                    Text("/ 100")
                        .font(.size12Regular)
                        .foregroundStyle(Color.gray400)
                }
            }
            .frame(width: 120, height: 120)

            Text("Overall Presence Score")
                .font(.size14Semibold)
                .foregroundStyle(Color.gray400)
        }
        .padding(.top, Spacing.s16)
    }

    private var scoreColor: Color {
        switch score {
        case 75...: return .successColour
        case 50..<75: return AppColors.warning
        default: return .red
        }
    }
}

private struct MetricCard: View {
    let icon: String
    let title: String
    let score: Int
    let detail: String

    var body: some View {
        HStack(spacing: Spacing.s16) {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(barColor.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .foregroundStyle(barColor)
                    .font(.size16Bold)
            }

            VStack(alignment: .leading, spacing: Spacing.s4) {
                HStack {
                    Text(title)
                        .font(.size14Semibold)
                        .foregroundStyle(Color.gray100)
                    Spacer()
                    Text("\(score)")
                        .font(.size13Semibold)
                        .foregroundStyle(barColor)
                }

                ProgressBar(progress: Double(score) / 100, color: barColor)

                Text(detail)
                    .font(.size12Regular)
                    .foregroundStyle(Color.gray400)
            }
        }
        .padding(Spacing.s16)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(Color.primaryNavy)
        }
    }

    private var barColor: Color {
        switch score {
        case 75...: return .successColour
        case 50..<75: return AppColors.warning
        default: return .red
        }
    }
}

private struct ProgressBar: View {
    let progress: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.gray600.opacity(0.3))
                Capsule().fill(color)
                    .frame(width: geo.size.width * max(0, min(progress, 1)))
            }
        }
        .frame(height: 6)
    }
}

private struct FaceVisibilityRow: View {
    let metrics: FaceVisibilityMetrics

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .foregroundStyle(Color.gray400)
            Text("Face visible for \(Int(metrics.visibleRatio * 100))% of the interview")
                .font(.size12Regular)
                .foregroundStyle(Color.gray400)
            Spacer()
        }
        .padding(.horizontal, Spacing.s4)
    }
}

private struct DisclaimerNote: View {
    var body: some View {
        Text("These are observational coaching metrics based on camera analysis, not a psychological assessment.")
            .font(.size12Regular)
            .foregroundStyle(Color.gray400)
            .multilineTextAlignment(.center)
            .padding(.top, Spacing.s8)
    }
}
