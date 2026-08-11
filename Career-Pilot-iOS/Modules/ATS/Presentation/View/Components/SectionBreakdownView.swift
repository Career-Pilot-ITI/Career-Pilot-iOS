//
//  SectionBreakdownView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.

import SwiftUI

private struct SectionRow: View {
    let section: SectionScore
    @Binding var expandedID: SectionScore.ID?

    private var isExpanded: Bool { expandedID == section.id }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expandedID = isExpanded ? nil : section.id
                }
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(section.color.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Text("\(section.score)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(section.color)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(section.name)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(section.color.opacity(0.15))
                                    .frame(height: 5)
                                Capsule()
                                    .fill(section.color)
                                    .frame(width: geo.size.width * CGFloat(section.score) / 100, height: 5)
                            }
                        }
                        .frame(height: 5)
                    }

                    if section.isLowest {
                        Text("LOWEST")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.matchRed)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.matchRed.opacity(0.12))
                            .clipShape(Capsule())
                    }

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .buttonStyle(.plain)

            if isExpanded, let detail = section.detail {
                Text(detail)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding(.leading, 52)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct SectionBreakdownCard: View {
    let sections: [SectionScore]
    @State private var expandedID: SectionScore.ID?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Section Breakdown")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)

            VStack(spacing: 18) {
                ForEach(sections) { section in
                    SectionRow(section: section, expandedID: $expandedID)
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
        .onAppear {
            // Mirrors the mockup, where "Education" starts expanded.
            expandedID = sections.last?.id
        }
    }
}

#Preview {
    SectionBreakdownCard(sections: JobMatchData.sample.sectionScores)
        .padding()
        .background(Color.screenBackground)
}
