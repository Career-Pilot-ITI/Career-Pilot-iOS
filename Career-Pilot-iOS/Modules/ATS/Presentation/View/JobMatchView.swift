//
//  JobMatchView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.


import SwiftUI

struct JobMatchView: View {
    let data: JobMatchData
//    var onBack: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
//            NavBar(onBack: onBack)

            ScrollView {
                VStack(spacing: Layout.cardSpacing) {
                    JobHeaderCard(job: data.job)

                    MatchScoreCardView(
                        score: data.matchScore,
                        label: data.matchLabel,
                        matchedCount: data.matchedCount,
                        missingCount: data.missingCount
                    )

                    SkillChipsCard(
                        title: "Matched Requirements",
                        badgeText: "\(data.matchedCount) of \(data.totalKeywords) keywords",
                        badgeColor: .matchGreen,
                        items: data.matchedRequirements,
                        status: .matched
                    )

                    SkillChipsCard(
                        title: "Missing Required Skills",
                        badgeText: "\(data.missingRequired.count) of \(data.totalKeywords) keywords",
                        badgeColor: .matchRed,
                        items: data.missingRequired,
                        status: .missingRequired
                    )

                    SkillChipsCard(
                        title: "Missing Preferred Skills",
                        badgeText: "\(data.missingPreferred.count) of \(data.totalKeywords) keywords",
                        badgeColor: .matchAmber,
                        items: data.missingPreferred,
                        status: .missingPreferred
                    )

                    StrengthsCard(strengths: data.strengths)
                    WeaknessesCard(weaknesses: data.weaknesses)

                    SectionBreakdownCard(sections: data.sectionScores)

                    RecommendationsCard(recommendations: data.recommendations)

                    ActionButtonsView()
                        .padding(.top, 4)
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.bottom, 24)
            }
        }
        .background(Color.screenBackground.ignoresSafeArea())
    }
}

#Preview {
    JobMatchView(data: .sample)
}
