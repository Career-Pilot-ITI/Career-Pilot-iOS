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

    private var isLinkedInJobURL: Bool {
        let trimmed = jobLink.trimmingCharacters(in: .whitespaces)
        guard let url = URL(string: trimmed),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return false
        }
        let host = components.host?.lowercased() ?? ""
        let path = components.path
        return (host == "www.linkedin.com" || host == "linkedin.com")
            && path.hasPrefix("/jobs/view/")
            && path.replacingOccurrences(of: "/jobs/view/", with: "")
                .drop(while: { $0 == "/" })
                .allSatisfy { $0.isNumber }
            && !path.replacingOccurrences(of: "/jobs/view/", with: "")
                .drop(while: { $0 == "/" })
                .isEmpty
    }

    private var isCompareEnabled: Bool {
        isLinkedInJobURL && viewModel.cvUploaded && !viewModel.isLoading
    }


    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(alignment: .leading) {
                ATSFeatureBadge()
                    .padding(.bottom, 8)
                    

                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Compare CV to Job")
                        .font(Font.size24Bold)

                    Text("Paste a job posting link — we'll score your CV against it instantly.")
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.bottom, 22)

                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text("Job Posting Link")
                        .font(Font.size13Bold)

                    JobLinkTextField(link: $jobLink)

                    if !jobLink.isEmpty && !isLinkedInJobURL {
                        Text("Please enter a valid LinkedIn job URL, e.g. https://www.linkedin.com/jobs/view/12345678/")
                            .font(Font.size12Regular)
                            .foregroundStyle(Color.matchRed)
                    } else {
                        Text("Supports LinkedIn job posting URLs only.")
                            .font(Font.size12Regular)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .padding(.bottom, 22)

                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text("CV on File")
                        .font(Font.size13Bold)

                    if viewModel.isUploadingCv {
                        CVUploadSkeletonView()
                    } else if viewModel.cvUploaded, let uploadDate = viewModel.cvUploadDate {
                        UploadedCVCard(
                            fileName: viewModel.cvFileName,
                            uploadDate: uploadDate
                        )
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
                HStack {
                    Spacer()
                    CustomButton(
                        isButtonEnabeld: isCompareEnabled,
                        showArrow: false,
                        buttonTitle: viewModel.isLoading ? "Comparing..." : "Compare Now",
                        onClick: {
                            guard isLinkedInJobURL else { return }
                            Task {
                                let success = await viewModel.fireRequest(jobURL: jobLink)
                                if success {
                                    coordinator.push(.atsjobDescription)
                                }
                            }
                        }
                    )
                    Spacer()
                }
            }
            .toolbar(.hidden,for: .tabBar)
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

private struct CVUploadSkeletonView: View {
    var body: some View {
        HStack(spacing: 12) {
            SkeletonBlock(height: 48, cornerRadius: Radius.r12)
                .frame(width: 48)
            VStack(alignment: .leading, spacing: Spacing.s8) {
                SkeletonPill(width: 160, height: 16)
                SkeletonPill(width: 130, height: 12)
            }
            Spacer()
            SkeletonBlock(height: 28, cornerRadius: 14)
                .frame(width: 28)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}
//
//#Preview {
//    ATSJobMatchView()
//}
