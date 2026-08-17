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
    @Published private(set) var scoringError: ATSScoringError?
    @Published var cvUploaded: Bool = false
    @Published var cvFileName: String = ""
    @Published var cvUploadDate: Date?

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
    private let userSession: UserSession
    private let toastManager: ToastManager

    // MARK: - Init

    init(
        getJobUseCase: GetJobByURLUseCase,
        scoreJobUseCase: ScoreCVAgainstJobUseCase,
        generateCoverLetterUseCase: GenerateCoverLetterUseCase,
        uploadCvUseCase: UploadCvUseCase,
        userRepo: UserDataRepo,
        userSession: UserSession,
        toastManager: ToastManager
    ) {
        self.getJobUseCase = getJobUseCase
        self.scoreJobUseCase = scoreJobUseCase
        self.generateCoverLetterUseCase = generateCoverLetterUseCase
        self.uploadCvUseCase = uploadCvUseCase
        self.userRepo = userRepo
        self.userSession = userSession
        self.toastManager = toastManager
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
            presentError(
                (error as? NetworkError)?.userMessage
                    ?? "Couldn't fetch that job posting. Please check the link and try again."
            )
            return false
        }
    }

    /// Scores the user's CV against the fetched job.
    /// Requires `currentJob` to be set first.
    func scoreCv() async {
        guard let workspaceId = currentJob?.workspaceID else {
            presentError("No job loaded. Please fetch a job first.")
            return
        }

        isScoringLoading = true
        errorMessage = nil
        scoringError = nil
        defer { isScoringLoading = false }

        do {
            let entity = try await scoreJobUseCase.execute(workspaceId)
            if let job = currentJob {
                jobMatchData = entity.toUIModel(job: job)
            }
        } catch let error as ATSScoringError {
            scoringError = error
            presentError(error.errorDescription ?? "Couldn't score your CV. Please try again.")
        } catch {
            let scoringError = ATSScoringError(error: error)
            self.scoringError = scoringError
            presentError(scoringError.errorDescription ?? "Couldn't score your CV. Please try again.")
        }
    }

    /// Generates a cover letter for the fetched job.
    /// Requires `currentJob` to be set first.
    func generateCoverLetter() async {
        guard let workspaceId = currentJob?.workspaceID else {
            presentError("No job loaded. Please fetch a job first.")
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
            if entity.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                coverLetterData = .fallback(
                    jobTitle: currentJob?.title ?? "this role",
                    companyName: currentJob?.companyName ?? "your company",
                    signature: contact
                )
            } else {
                coverLetterData = entity.toUIModel(userContact: contact)
            }
        } catch {
            presentError(
                (error as? NetworkError)?.userMessage
                    ?? "Couldn't generate the cover letter. Please try again."
            )
        }
    }

    /// Checks whether the user has a CV on file.
    func isCvFound() async {
        isUploadingCv = false
        do {
            let profile = try await userRepo.getCurrentUser()?.profile
            let cvURL = profile?.cvURL ?? ""
            cvUploaded = !cvURL.isEmpty
            if cvUploaded {
                cvFileName = (cvURL as NSString).lastPathComponent
                cvUploadDate = Date()
            } else {
                cvFileName = ""
                cvUploadDate = nil
            }
        } catch {
            presentError((error as? NetworkError)?.userMessage ?? "Couldn't check your CV. Please try again.")
        }
    }

    /// Uploads a CV file picked by the user, then refreshes the CV status.
    func uploadCv(url: URL) async {
        guard var user = try? await userRepo.getCurrentUser() else {
            presentError("Please log in again before uploading your CV.")
            return
        }

        isUploadingCv = true
        errorMessage = nil
        defer { isUploadingCv = false }

        do {
            let response = try await uploadCvUseCase.execute(UploadCvRequest(cv: url))
            let serverCvURL = response.userData.cv?.absoluteString ?? ""

            user.profile = UserProfile(
                displayName: user.profile.displayName,
                username: user.profile.username,
                email: user.profile.email,
                avatarURL: user.profile.avatarURL,
                gender: user.profile.gender,
                dateOfBirth: user.profile.dateOfBirth,
                targetRole: user.profile.targetRole,
                industry: user.profile.industry,
                experienceLevel: user.profile.experienceLevel,
                currentJobTitle: user.profile.currentJobTitle,
                yearsOfExperience: user.profile.yearsOfExperience,
                cvURL: serverCvURL,
                skills: user.profile.skills,
                targetCompanies: user.profile.targetCompanies,
                educationLevel: user.profile.educationLevel,
                timezone: user.profile.timezone,
                termsAccepted: user.profile.termsAccepted,
                subscriptionTier: user.profile.subscriptionTier,
                coinBalance: user.profile.coinBalance,
                onboardingCompleted: user.profile.onboardingCompleted,
                trackId: user.profile.trackId
            )
            try? await userRepo.saveUser(user)
            try? await userSession.reload()

            cvUploaded = true
            cvFileName = url.lastPathComponent
            cvUploadDate = Date()
        } catch {
            presentError(
                (error as? NetworkError)?.userMessage
                    ?? "Couldn't upload your CV. Please try again."
            )
        }
    }

    func practiceTrackId() async -> Int? {
        do {
            let user = try await userRepo.getCurrentUser()
            guard let trackId = user?.profile.trackId,
                  trackId > 0 else {
                presentError("Choose a career track before starting a practice session.")
                return nil
            }
            return trackId
        } catch {
            presentError("Couldn't prepare your practice session. Please try again.")
            return nil
        }
    }

    private func presentError(_ message: String) {
        errorMessage = message
        toastManager.show(message, type: .error)
    }
}
