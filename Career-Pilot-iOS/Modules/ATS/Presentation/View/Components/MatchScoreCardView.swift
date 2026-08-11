//
//  MatchScoreCardView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

struct MatchScoreCardView: View {
    let score: Int
    let label: String
    let matchedCount: Int
    let missingCount: Int

    private var progress: CGFloat {
        CGFloat(score) / 100.0
    }

    private var barSplit: CGFloat {
        let total = matchedCount + missingCount
        guard total > 0 else { return 0 }
        return CGFloat(matchedCount) / CGFloat(total)
    }

    var body: some View {
        VStack(spacing: 18) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(Color.matchOrange.opacity(0.15), lineWidth: 8)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.matchOrange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))

                    Text("\(score)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                }
                .frame(width: 84, height: 84)

                VStack(alignment: .leading, spacing: 6) {
                    Text("MATCH SCORE")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(0.5)

                    Text(label)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)

                    HStack(spacing: 14) {
                        Label("\(matchedCount) matched", systemImage: "checkmark")
                            .labelStyle(.titleAndIcon)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.matchGreen)

                        Label("\(missingCount) missing", systemImage: "xmark")
                            .labelStyle(.titleAndIcon)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.matchRed)
                    }
                }

                Spacer()
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.matchRed.opacity(0.25))
                        .frame(height: 6)

                    Capsule()
                        .fill(Color.matchOrange)
                        .frame(width: geo.size.width * barSplit, height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(18)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

#Preview {
    MatchScoreCardView(score: 78, label: "Good Match", matchedCount: 8, missingCount: 5)
        .padding()
        .background(Color.screenBackground)
}
