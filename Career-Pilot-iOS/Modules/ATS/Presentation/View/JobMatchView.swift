//
//  JobMatchView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

struct JobMatchView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @EnvironmentObject var viewModel: ATSViewModel

    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()

            if viewModel.isScoringLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Scoring your CV…")
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                }

            } else if let data = viewModel.jobMatchData {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: Radius.r16) {
                            if let job = viewModel.jobDescriptionModel {
                                JobHeaderCard(job: job) { }
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

                            ActionButtonsView(onGenerateCoverLetter: {
                                coordinator.push(.coverLetter)
                            })
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, Radius.r16)
                        .padding(.bottom, 24)
                    }
                    .scrollIndicators(.hidden)
                }

            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(Color.matchRed)
                    Text(errorMessage)
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            } else {
                ProgressView("Preparing…")
            }
        }
        .navigationTitle("Job Match")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Only score if we don't already have results
            guard viewModel.jobMatchData == nil else { return }
            await viewModel.scoreCv()
        }
    }
}

#Preview {
    JobMatchView()
}
