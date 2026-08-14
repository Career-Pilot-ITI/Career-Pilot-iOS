//
//  OverallScoreCardView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//
import SwiftUI

struct OverallScoreCardView: View {
    let score: Int
    let performanceLabel: String
    let percentileText: String
    let maxScore: Int = 100
    var colorProgress : Color {
        switch score {
        case 0..<50:
            return Color.red
        case 50..<80:
            return Color.primaryYellow
        case 80...100:
            return Color.successColour
        default :
            return Color.gray
        }
    }

    @State private var animatedProgress: CGFloat = 0
    @State private var animatedColorProgress: Color = Color.red

    private var targetProgress: CGFloat {
        CGFloat(score) / CGFloat(maxScore)
    }

    var body: some View {
        HStack(spacing: Spacing.s20) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        animatedColorProgress,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                Text("\(score)")
                    .font(Font.size22Bold)
                    .foregroundStyle(.white)
            }
            .frame(width: 76, height: 76)
            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("OVERALL SCORE")
                    .font(Font.size12Bold)
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(0.5)
                Text(performanceLabel)
                    .font(Font.size20Bold)
                    .foregroundStyle(.white)
                Text(percentileText)
                    .font(Font.size14Regular)
                    .foregroundStyle(Color.tealAccent)
            }
            Spacer()
        }
        .padding(.all, 20)
        .background {
            RoundedRectangle(cornerRadius: Radius.r16)
                .fill(
                    LinearGradient(
                        colors: [Color.primaryNavy, Color.primaryNavy.opacity(0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = targetProgress
                animatedColorProgress = colorProgress
            }
        }
    }
}

//#Preview {
//    ZStack {
//        Color.lightBackGround.ignoresSafeArea()
//        OverallScoreCardView(
//            score: 82,
//            performanceLabel: "Strong Performance",
//            percentileText: "Top 28% of users this week"
//        )
//        .padding(.horizontal, 24)
//    }
//}
