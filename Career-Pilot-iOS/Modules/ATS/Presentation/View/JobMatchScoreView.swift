//
//  JobMatchScoreView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.

import SwiftUI

struct JobMatchScoreView: View {
    let jobMatch: JobMatch

    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    JobHeaderCard(
                        initial: jobMatch.companyInitial,
                        title: jobMatch.jobTitle,
                        companyName: jobMatch.companyName,
                        location: jobMatch.location,
                        workMode: jobMatch.workMode
                    )

                    MatchScoreCard(
                        score: jobMatch.score,
                        matchLabel: jobMatch.matchLabel,
                        matchedCount: jobMatch.matchedKeywords.count,
                        missingCount: jobMatch.missingKeywords.count
                    )

                    matchedRequirementsSection
                    missingRequirementsSection
                    suggestedEditsEntryPoint
                }
                .padding(16)
            }
            .scrollIndicators(.hidden)
            .background(Color.lightBackGround.ignoresSafeArea())
            .navigationTitle("Job Match")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var matchedRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(
                title: "Matched Requirements",
                trailingText: "\(jobMatch.matchedKeywords.count) of \(jobMatch.totalKeywordCount) keywords"
            )
            FlowLayout(spacing: 10) {
                ForEach(jobMatch.matchedKeywords, id: \.self) { KeywordChip(text: $0) }
            }
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

    private var missingRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionHeader(
                title: "Missing Requirements",
                trailingText: "\(jobMatch.priorityMissingCount) priority keywords",
                trailingColor: Color.priorityHigh
            )
            VStack(spacing: 0) {
                ForEach(Array(jobMatch.missingKeywords.enumerated()), id: \.element.id) { index, keyword in
                    MissingRequirementRow(keyword: keyword)
                    if index < jobMatch.missingKeywords.count - 1 {
                        Divider().background(Color.separator)
                    }
                }
            }
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

    private var suggestedEditsEntryPoint: some View {
        NavigationLink {
            SuggestedResumeEditsView(jobMatch: jobMatch)
        } label: {
            HStack {
                Text("Suggested Resume Edits")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.textTertiary)
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
}

#Preview {
    NavigationStack {
        JobMatchScoreView(jobMatch: .mock)
    }
    .preferredColorScheme(.light)
}
