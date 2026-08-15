//
//  ATSJobMatchView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

struct ATSJobMatchView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @EnvironmentObject var viewModel: ATSViewModel
    @State private var jobLink: String = ""
    @State private var showCvUploadSheet: Bool = false

    private var isCompareEnabled: Bool {
        !jobLink.trimmingCharacters(in: .whitespaces).isEmpty && viewModel.cvUploaded && !viewModel.isLoading
    }


    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()

            VStack(alignment: .leading) {
                ATSFeatureBadge()
                    .padding(.bottom, 8)
                    

                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Compare CV to Job")
                        .font(Font.size24Bold)
                        .foregroundStyle(Color.textPrimary)

                    Text("Paste a job posting link — we'll score your CV against it instantly.")
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.bottom, 22)

                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text("Job Posting Link")
                        .font(Font.size13Bold)
                        .foregroundStyle(Color.textPrimary)

                    JobLinkTextField(link: $jobLink)

                    Text("Supports LinkedIn, Indeed, Wuzzuf, Glassdoor, and direct job-page URLs.")
                        .font(Font.size12Regular)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.bottom, 22)

                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text("CV on File")
                        .font(Font.size13Bold)
                        .foregroundStyle(Color.textPrimary)

                    if viewModel.isUploadingCv {
                        HStack(spacing: 12) {
                            ProgressView()
                            Text("Uploading CV…")
                                .font(Font.size14Regular)
                                .foregroundStyle(Color.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                    } else if viewModel.cvUploaded {
                        UploadedCVCard()
                    } else {
                        CvUploadingView(
                            didUpload: false,
                            baseSentance: "Upload your CV",
                            subSentanceOne: "PDF or DOC · Max 10 MB"
                        )
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            showCvUploadSheet = true
                        }
                    }
                }
                .padding(.bottom, 20)

                JobLinkShareTipView()

                Spacer()

                CustomButton(
                    isButtonEnabeld: isCompareEnabled,
                    showArrow: false,
                    buttonTitle: viewModel.isLoading ? "Comparing..." : "Compare Now",
                    onClick: {
                        Task {
                            let success = await viewModel.fireRequest(jobURL: jobLink)
                            if success {
                                coordinator.push(.atsjobDescription)
                            }
                        }
                    }
                )
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.top, Spacing.s16)
            .task {
                await viewModel.isCvFound()
            }
            .sheet(isPresented: $showCvUploadSheet) {
                CvUploadSheet { pickedURL in
                    Task {
                        await viewModel.uploadCv(url: pickedURL)
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ATSJobMatchView()
}
