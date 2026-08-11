//
//  ATSJobMatchView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

struct ATSJobMatchView: View {
    @State private var jobLink: String = ""
    @State private var cvUploaded: Bool = true
    @StateObject private var viewmodel : ATSViewModel = ATSViewModel(getJobUseCase: GetJobByURLUseCase(repository: ATSRepository(localDataSource: ATSRemoteDataSource(networkService:URLSessionNetworkService()))))

    private var isCompareEnabled: Bool {
        !jobLink.trimmingCharacters(in: .whitespaces).isEmpty && cvUploaded
    }

    var body: some View {
        ZStack {
            Color.lightBackGround.ignoresSafeArea()

            VStack(alignment: .leading, spacing: Spacing.s16) {

                ATSFeatureBadge()

                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Compare CV to Job")
                        .font(Font.size22Bold)
                        .foregroundStyle(Color.textPrimary)

                    Text("Paste a job posting link — we'll score your CV against it instantly.")
                        .font(Font.size14Regular)
                        .foregroundStyle(Color.textSecondary)
                }

                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text("Job Posting Link")
                        .font(Font.size12Bold)
                        .foregroundStyle(Color.textPrimary)

                    JobLinkTextField(link: $jobLink)

                    Text("Supports LinkedIn, Indeed, Wuzzuf, Glassdoor, and direct job-page URLs.")
                        .font(Font.size12Regular)
                        .foregroundStyle(Color.textSecondary)
                }

                VStack(alignment: .leading, spacing: Spacing.s8) {
                    Text("CV on File")
                        .font(Font.size12Bold)
                        .foregroundStyle(Color.textPrimary)

                    if cvUploaded {
                        UploadedCVCard()
                    } else {
                        CvUploadingView(
                            didUpload: false,
                            baseSentance: "Upload your CV",
                            subSentanceOne: "PDF or DOC · Max 10 MB"
                        )
                    }
                }

                Spacer()

                JobLinkShareTipView()

                CustomButton(isButtonEnabeld: isCompareEnabled, buttonTitle: "Compare Now") {
                    // compare Logic
                }
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s12)
            .task {
                await viewmodel.fireRequest()
            }
        }
    }
}

#Preview {
    ATSJobMatchView()
}
