//
//  JobDescriptionView.swift
//  Career-Pilot-iOS
//

import SwiftUI

struct JobDescriptionView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @EnvironmentObject var viewModel: ATSViewModel
    @State private var selectedPostingURL: URL?
    @State private var isShowingPosting = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.lightBackGround.ignoresSafeArea()

            if let job = viewModel.jobDescriptionModel {
                ScrollView {
                    VStack(spacing: 16) {
                        JobHeaderCard(job: job, onOpenLink: job.postingURL.map { url in
                            {
                                selectedPostingURL = url
                                isShowingPosting = true
                            }
                        })
                        OverViewCardView(job: job)
                        JobDescriptionCardView(job: job)
                        JobRequirementsCardView(job: job)
                    }
                    .padding(16)
                    .padding(.bottom, 90) // room for the sticky button
                }
                .scrollIndicators(.hidden)

                CustomButton(
                    showArrow: false,
                    buttonTitle: "Start Scoring") {
                        coordinator.push(.atsJobmatchScore)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

            } else {
                JobDescriptionSkeletonView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Job Description"))
        .sheet(isPresented: $isShowingPosting) {
            if let selectedPostingURL {
                JobPostingSafariView(url: selectedPostingURL)
                    .ignoresSafeArea()
            }
        }
    }

}

private struct JobDescriptionSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SkeletonBlock(height: 112)
                SkeletonBlock(height: 150)
                SkeletonBlock(height: 260)
                SkeletonBlock(height: 220)
            }
            .padding(16)
            .padding(.bottom, 90)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Preview


