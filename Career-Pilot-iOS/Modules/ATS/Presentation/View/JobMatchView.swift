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
    var onBuyCoins: () -> Void = {}
    @State private var selectedPostingURL: URL?
    @State private var isShowingPosting = false

    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()

            if viewModel.isScoringLoading || (viewModel.jobMatchData == nil && viewModel.errorMessage == nil) {
                JobMatchSkeletonView()

            } else if let data = viewModel.jobMatchData {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: Radius.r16) {
                            if let job = viewModel.jobDescriptionModel {
                                JobHeaderCard(job: job, onOpenLink: job.postingURL.map { url in
                                    {
                                        selectedPostingURL = url
                                        isShowingPosting = true
                                    }
                                })
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

                            ActionButtonsView(onApplyEdits: {
                                coordinator.push(.cvOptimizeProgress)
                            }, onGenerateCoverLetter: {
                                coordinator.push(.coverLetter)
                            }, onStartPractice: {
                                Task {
                                    guard let trackId = await viewModel.practiceTrackId() else { return }
                                    let jobTitle = viewModel.currentJob?.title ?? "this job"
                                    coordinator.push(
                                        .practiceInterview(
                                            trackName: jobTitle,
                                            trackId: trackId,
                                            interviewType: .classic
                                        )
                                    )
                                }
                            })
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, Radius.r16)
                        .padding(.bottom, 24)
                    }
                    .scrollIndicators(.hidden)
                }

            } else if let scoringError = viewModel.scoringError {
                scoringErrorView(scoringError)
            } else {
                EmptyView()
            }
        }
        .navigationTitle("Job Match")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingPosting) {
            if let selectedPostingURL {
                JobPostingSafariView(url: selectedPostingURL)
                    .ignoresSafeArea()
            }
        }
        .task {
            // Only score if we don't already have results
            guard viewModel.jobMatchData == nil else { return }
            await viewModel.scoreCv()
        }
    }

    @ViewBuilder
    private func scoringErrorView(_ error: ATSScoringError) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(Color.matchRed)
            Text(error.errorDescription ?? "Couldn't score your CV. Please try again.")
                .font(Font.size14Regular)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if error.isInsufficientCoins {
                Button("Buy Coins") {
                    onBuyCoins()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.activeColour)
            } else {
                Button("Retry") {
                    Task { await viewModel.scoreCv() }
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct JobMatchSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Radius.r16) {
                SkeletonBlock(height: 112)
                scoreCard
                skillCard(rows: 3)
                skillCard(rows: 2)
                skillCard(rows: 2)
                SkeletonBlock(height: 112)
                SkeletonBlock(height: 112)
                SkeletonBlock(height: 250)
                SkeletonBlock(height: 210)
                SkeletonBlock(height: 56)
            }
            .padding(.horizontal, Radius.r16)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }

    private var scoreCard: some View {
        HStack(spacing: 20) {
            SkeletonBlock(height: 72, cornerRadius: 36)
                .frame(width: 72)
            VStack(alignment: .leading, spacing: 10) {
                SkeletonPill(width: 100, height: 12)
                SkeletonPill(width: 150, height: 20)
                SkeletonPill(width: 180, height: 12)
            }
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }

    private func skillCard(rows: Int) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SkeletonPill(width: 170, height: 16)
            HStack(spacing: 8) {
                ForEach(0..<rows, id: \.self) { index in
                    SkeletonPill(width: index == 0 ? 90 : 70, height: 28)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

//#Preview {
//    JobMatchView()
//}
