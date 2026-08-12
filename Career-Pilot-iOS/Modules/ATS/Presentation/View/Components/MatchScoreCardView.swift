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
                .frame(width: 72, height: 72)

                VStack(alignment: .leading, spacing: 6) {
                    Text("MATCH SCORE")
                        .font(Font.size11Bold)
                        .foregroundColor(Color.textSecondary)
                        .tracking(0.5)

                    Text(label)
                        .font(Font.size18Bold)
                        .foregroundColor(Color.textPrimary)

                    HStack(spacing: 14) {
                        Label("\(matchedCount) matched", systemImage: "checkmark")
                            .labelStyle(.titleAndIcon)
                            .font(Font.size11Medium)
                            .foregroundColor(.matchGreen)

                        Label("\(missingCount) missing", systemImage: "xmark")
                            .labelStyle(.titleAndIcon)
                            .font(Font.size11Medium)
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
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16))
        .overlay {
            RoundedRectangle(cornerRadius: Radius.r16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        
    }
}

#Preview {
    MatchScoreCardView(score: 78, label: "Good Match", matchedCount: 8, missingCount: 5)
}
