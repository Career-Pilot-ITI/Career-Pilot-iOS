//
//  JobMatchView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.


import SwiftUI

struct JobMatchView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    let data: JobMatchData

    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: Radius.r16) {
                        JobHeaderCard(job: JobDescriptionModel.mock) {
                            //
                        }

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

                        ActionButtonsView( onGenerateCoverLetter: {
                            coordinator.push(.coverLetter)
                        })
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, Radius.r16)
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Job Match")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    JobMatchView(data: .sample)
}
