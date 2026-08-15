//
//  MatchScoreCard.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.

import SwiftUI

struct MatchScoreCard: View {
    let score: Int
    let matchLabel: String
    let matchedCount: Int
    let missingCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 16) {
                ScoreRingView(score: score)

                VStack(alignment: .leading, spacing: 6) {
                    Text("MATCH SCORE")
                        .font(Font.size11Bold)
                        .foregroundColor(Color.textTertiary)
                        .tracking(0.5)
                    Text(matchLabel)
                        .font(Font.size18Bold)
                        .foregroundColor(Color.textPrimary)
                    HStack(spacing: 8) {
                        StatusPill(text: "\(matchedCount) matched", symbol: "checkmark", color: Color.accentTeal)
                        StatusPill(text: "\(missingCount) missing", symbol: "xmark", color: Color.priorityHigh)
                    }
                }
                Spacer()
            }

            ScoreProgressBar(progress: Double(score) / 100)
        }
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}

private struct StatusPill: View {
    let text: String
    let symbol: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: symbol)
                .font(.system(size: 9, weight: .bold))
            Text(text)
                .font(Font.size11Medium)
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(color.opacity(0.09))
        .clipShape(Capsule())
    }
}

#Preview {
    MatchScoreCard(score: 73, matchLabel: "Good Match", matchedCount: 8, missingCount: 5)
        .padding()
}
