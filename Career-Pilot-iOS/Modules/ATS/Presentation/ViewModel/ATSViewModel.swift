//
//  ATSViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

@MainActor
class ATSViewModel: ObservableObject {

    // MARK: - Published State

    /// True while `fireRequest` (fetch job) is in progress
    @Published var isLoading: Bool = false
    /// True while `scoreCv` is in progress
    @Published var isScoringLoading: Bool = false
    /// True while `generateCoverLetter` is in progress
    @Published var isCoverLetterLoading: Bool = false
    /// True while CV upload is in progress
    @Published var isUploadingCv: Bool = false

    @Published var errorMessage: String?
    @Published var cvUploaded: Bool = false

    /// Raw domain entity — kept for workspaceID access in downstream calls
    @Published var currentJob: JobEntity?

    /// UI models – consumed by the individual screens
    @Published var jobDescriptionModel: JobDescriptionModel?
    @Published var jobMatchData: JobMatchData?
    @Published var coverLetterData: CoverLetterData?

    // MARK: - Dependencies

    private let getJobUseCase: GetJobByURLUseCase
    private let scoreJobUseCase: ScoreCVAgainstJobUseCase
    private let generateCoverLetterUseCase: GenerateCoverLetterUseCase
    private let uploadCvUseCase: UploadCvUseCase
    private let userRepo: UserDataRepo

    // MARK: - Init

    init(
        getJobUseCase: GetJobByURLUseCase,
        scoreJobUseCase: ScoreCVAgainstJobUseCase,
        generateCoverLetterUseCase: GenerateCoverLetterUseCase,
        uploadCvUseCase: UploadCvUseCase,
        userRepo: UserDataRepo
    ) {
        self.getJobUseCase = getJobUseCase
        self.scoreJobUseCase = scoreJobUseCase
        self.generateCoverLetterUseCase = generateCoverLetterUseCase
        self.uploadCvUseCase = uploadCvUseCase
        self.userRepo = userRepo
    }

    // MARK: - Actions

    /// Fetches the job from the given URL and maps it to the description UI model.
    /// Returns `true` on success so the caller can navigate forward.
    func fireRequest(jobURL: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let entity = try await getJobUseCase.execute(jobURL)
            currentJob = entity
            jobDescriptionModel = entity.toDescriptionModel()
            return true
        } catch {
            errorMessage = "Couldn't fetch that job posting. Please check the link and try again."
            return false
        }
    }

    /// Scores the user's CV against the fetched job.
    /// Requires `currentJob` to be set first.
    func scoreCv() async {
        guard let workspaceId = currentJob?.workspaceID else {
            errorMessage = "No job loaded. Please fetch a job first."
            return
        }

        isScoringLoading = true
        errorMessage = nil
        defer { isScoringLoading = false }

        do {
            let entity = try await scoreJobUseCase.execute(workspaceId)
            if let job = currentJob {
                jobMatchData = entity.toUIModel(job: job)
            }
        } catch {
            errorMessage = "Couldn't score your CV. Please try again."
        }
    }

    /// Generates a cover letter for the fetched job.
    /// Requires `currentJob` to be set first.
    func generateCoverLetter() async {
        guard let workspaceId = currentJob?.workspaceID else {
            errorMessage = "No job loaded. Please fetch a job first."
            return
        }

        isCoverLetterLoading = true
        errorMessage = nil
        defer { isCoverLetterLoading = false }

        do {
            let entity = try await generateCoverLetterUseCase.execute(workspaceId)
            // Build a contact from the cached user profile if available
            let profile = try? await userRepo.getCurrentUser()?.profile
            let contact = SignatureContact(
                name: profile?.displayName ?? "",
                email: profile?.email ?? "",
                phone: ""
            )
            coverLetterData = entity.toUIModel(userContact: contact)
        } catch {
            errorMessage = "Couldn't generate the cover letter. Please try again."
        }
    }

    /// Checks whether the user has a CV on file.
    func isCvFound() async {
        do {
            let profile = try await userRepo.getCurrentUser()?.profile
            cvUploaded = !(profile?.cvURL ?? "").isEmpty
        } catch {
            print("isCvFound error: \(error)")
        }
    }

    /// Uploads a CV file picked by the user, then refreshes the CV status.
    func uploadCv(url: URL) async {
        isUploadingCv = true
        errorMessage = nil
        defer { isUploadingCv = false }

        do {
            _ = try await uploadCvUseCase.execute(UploadCvRequest(cv: url))
            cvUploaded = true
        } catch {
            errorMessage = "Couldn't upload your CV. Please try again."
        }
    }
}
