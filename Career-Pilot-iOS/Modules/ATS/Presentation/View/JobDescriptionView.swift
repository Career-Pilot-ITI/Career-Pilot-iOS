//
//  JobDescriptionView.swift
//  Career-Pilot-iOS
//

import SwiftUI

struct JobDescriptionView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @EnvironmentObject var viewModel: ATSViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.lightBackGround.ignoresSafeArea()

            if let job = viewModel.jobDescriptionModel {
                ScrollView {
                    VStack(spacing: 16) {
                        JobHeaderCard(job: job) {
                            // open source link
                        }
                        OverViewCardView(job: job)
                        JobDescriptionCardView(job: job)
                        JobRequirementsCardView(job: job)
                    }
                    .padding(16)
                    .padding(.bottom, 90) // room for the sticky button
                }
                .scrollIndicators(.hidden)

                startScoringButton
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

            } else {
                ProgressView("Loading job…")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Job Description"))
    }

    // MARK: - Sticky Button

    private var startScoringButton: some View {
        Button(action: {
            coordinator.push(.atsJobmatchScore)
        }) {
            Text("Start Scoring")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange)
                )
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        JobDescriptionView()
            .environmentObject(AppCoordinator<HomeRoute>())
    }
}
