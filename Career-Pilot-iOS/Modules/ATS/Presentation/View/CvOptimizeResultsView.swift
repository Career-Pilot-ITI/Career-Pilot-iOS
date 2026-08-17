//
//  CvOptimizeResultsView.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import SwiftUI

struct CvOptimizeResultsView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @EnvironmentObject var viewModel: CvOptimizeViewModel

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            if let result = viewModel.completedResult {
                ScrollView {
                    VStack(spacing: Spacing.s16) {
                        // MARK: - Header
                        headerSection(result: result)

                        // MARK: - Sections
                        ForEach(result.sections) { section in
                            OptimizeSectionCard(section: section)
                        }
                    }
                    .padding(.horizontal, Radius.r16)
                    .padding(.bottom, Spacing.s24)
                }
                .scrollIndicators(.hidden)
            } else {
                // Fallback if navigated here without data
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.textTertiary)

                    Text("No optimization results available.")
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .navigationTitle("CV Optimization")
        .navigationBarTitleDisplayMode(.inline)
        .toast(ToastManager.shared)
    }

    // MARK: - Header

    @ViewBuilder
    private func headerSection(result: CvOptimizationResult) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            // Title
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Optimization Results")
                        .font(Font.size22Bold)
                        .foregroundStyle(Color.textPrimary)

                    Text("\(result.sections.count) sections analyzed")
                        .font(Font.size13Regular)
                        .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                // Coin cost (only for FREE tier)
                if result.coinCost > 0 {
                    CoinCostBadge(cost: result.coinCost)
                }
            }

            // Recommended tracks
            if !result.recommendedTracks.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recommended Tracks")
                        .font(Font.size13Bold)
                        .foregroundStyle(Color.textSecondary)

                    FlowLayout(spacing: 8) {
                        ForEach(result.recommendedTracks, id: \.self) { track in
                            TrackChip(title: track, isSelected: false)
                        }
                    }
                }
                .padding(16)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
            }

            // Summary stats
            summaryStatsRow(result: result)
        }
    }

    private func summaryStatsRow(result: CvOptimizationResult) -> some View {
        let totalImprovements = result.sections.reduce(0) { $0 + $1.improvements.count }
        let strongSections = result.sections.filter { $0.improvements.isEmpty }.count
        let avgScore = result.sections.isEmpty
            ? 0
            : result.sections.reduce(0) { $0 + $1.score } / result.sections.count

        return HStack(spacing: 12) {
            StatPill(icon: "sparkles", label: "Improvements", value: "\(totalImprovements)")
            StatPill(icon: "checkmark.shield", label: "Strong", value: "\(strongSections)")
            StatPill(icon: "chart.bar", label: "Avg Score", value: "\(avgScore)")
        }
    }
}

// MARK: - Stat Pill

private struct StatPill: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.activeColour)

            Text(value)
                .font(Font.size18Bold)
                .foregroundStyle(Color.textPrimary)

            Text(label)
                .font(Font.size11Medium)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r12, style: .continuous))
    }
}

//#Preview {
//    CvOptimizeResultsView()
//}
