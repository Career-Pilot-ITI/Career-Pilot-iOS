//
//  CoverLetterView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import SwiftUI

struct CoverLetterView: View {
    @EnvironmentObject var viewModel: ATSViewModel

    var body: some View {
        Group {
            if viewModel.isCoverLetterLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Generating cover letter…")
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.screenBackground.ignoresSafeArea())

            } else if let data = viewModel.coverLetterData {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: Radius.r16) {
                            CoverLetterCardView(data: data)
                            NextStepsCard(steps: data.nextSteps)
                            SendEmailButton()
                                .padding(.top, 4)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
                .background(Color.screenBackground.ignoresSafeArea())

            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(Color.matchRed)
                    Text(error)
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Button("Retry") {
                        Task { await viewModel.generateCoverLetter() }
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.screenBackground.ignoresSafeArea())

            } else {
                ProgressView("Loading…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.screenBackground.ignoresSafeArea())
            }
        }
        .task {
            // Only generate if we don't already have a result
            guard viewModel.coverLetterData == nil else { return }
            await viewModel.generateCoverLetter()
        }
    }
}

#Preview {
    CoverLetterView()
}
