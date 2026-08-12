//
//  ATSJobMatchView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import SwiftUI

struct ATSJobMatchView: View {
    @EnvironmentObject var coordinator: AppCoordinator<HomeRoute>
    @State private var jobLink: String = ""
    @State private var cvUploaded: Bool = true
    @StateObject private var viewmodel : ATSViewModel = ATSViewModel(getJobUseCase: GetJobByURLUseCase(repository: ATSRepository(remoteDataSource: ATSRemoteDataSource(networkService:URLSessionNetworkService()))),scoreJobUseCase: ScoreCVAgainstJobUseCase(repository: ATSRepository(remoteDataSource: ATSRemoteDataSource(networkService:URLSessionNetworkService()))))

    private var isCompareEnabled: Bool {
        !jobLink.trimmingCharacters(in: .whitespaces).isEmpty && cvUploaded && !viewmodel.isLoading
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
                .padding(.bottom, 20)

                JobLinkShareTipView()

                Spacer()

                CustomButton(
                    isButtonEnabeld: isCompareEnabled,
                    showArrow: false,
                    buttonTitle: viewmodel.isLoading ? "Comparing..." : "Compare Now",
                    onClick: {
                        Task {
                            let success = await viewmodel.fireRequest(jobURL: jobLink)
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
                let userRepo = UserDataRepoImp(remoteDataSource: UserDataRemoteDataSourceImp(networkService: URLSessionNetworkService()), localDataSource: UserLocalDataSourceImpl(coreData: CoreDataManager()))
                
                do {
                    let result = try  await userRepo.getCurrentUser()
                    print("My User Result: \(result)")

                }catch(let error){
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ATSJobMatchView()
}
