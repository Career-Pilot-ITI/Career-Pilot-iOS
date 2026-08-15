//
//  CvOptimizeResultsComponents.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import SwiftUI

// MARK: - Score Ring (small, for section headers)

struct SectionScoreRing: View {
    let score: Int

    private var color: Color {
        if score >= 80 { return .matchGreen }
        if score >= 50 { return .matchAmber }
        return .matchRed
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
                .frame(width: 44, height: 44)

            Circle()
                .trim(from: 0, to: Double(score) / 100.0)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 44, height: 44)
                .rotationEffect(.degrees(-90))

            Text("\(score)")
                .font(Font.size12Bold)
                .foregroundStyle(color)
        }
    }
}

// MARK: - Section Card

struct OptimizeSectionCard: View {
    let section: CvSection
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    SectionScoreRing(score: section.score)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(section.name)
                            .font(Font.size16SemiBold)
                            .foregroundStyle(Color.textPrimary)

                        Text(improvementsSummary)
                            .font(Font.size12Regular)
                            .foregroundStyle(Color.textSecondary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider()
                    .padding(.horizontal, 16)

                if section.improvements.isEmpty {
                    // Strong section — no changes needed
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.matchGreen)

                        Text("This section is already strong — no changes needed.")
                            .font(Font.size14Medium)
                            .foregroundStyle(Color.matchGreen)
                    }
                    .padding(16)
                } else {
                    VStack(spacing: 0) {
                        ForEach(section.improvements) { improvement in
                            ImprovementCard(improvement: improvement)

                            if improvement.id != section.improvements.last?.id {
                                Divider()
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }

    private var improvementsSummary: String {
        if section.improvements.isEmpty {
            return "No changes needed"
        }
        let count = section.improvements.count
        return "\(count) improvement\(count == 1 ? "" : "s") suggested"
    }
}

// MARK: - Improvement Card

struct ImprovementCard: View {
    let improvement: CvSectionImprovement
    @State private var showOriginal: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Improved text (main)
            VStack(alignment: .leading, spacing: 4) {
                Label("Improved", systemImage: "sparkles")
                    .font(Font.size11Semibold)
                    .foregroundStyle(Color.matchGreen)

                Text(improvement.improved)
                    .font(Font.size14Regular)
                    .foregroundStyle(Color.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Toggle to show original
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showOriginal.toggle()
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: showOriginal ? "eye.slash" : "eye")
                        .font(.system(size: 11))
                    Text(showOriginal ? "Hide original" : "Show original")
                        .font(Font.size12Medium)
                }
                .foregroundStyle(Color.textTertiary)
            }
            .buttonStyle(.plain)

            if showOriginal {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Original", systemImage: "doc.text")
                        .font(Font.size11Semibold)
                        .foregroundStyle(Color.textTertiary)

                    Text(improvement.original)
                        .font(Font.size13Regular)
                        .foregroundStyle(Color.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .strikethrough(true, color: Color.matchRed.opacity(0.4))
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Reason
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.matchAmber)

                Text(improvement.reason)
                    .font(Font.size12Regular)
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .background(Color.amberCardBg)
            .clipShape(RoundedRectangle(cornerRadius: Radius.r8, style: .continuous))
        }
        .padding(16)
    }
}

// MARK: - Coin Cost Badge

struct CoinCostBadge: View {
    let cost: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "bitcoinsign.circle.fill")
                .font(.system(size: 14))
            Text("\(cost) coins")
                .font(Font.size12Semibold)
        }
        .foregroundStyle(Color.matchAmber)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.amberCardBg)
        .clipShape(Capsule())
    }
}
