//
//  ATSViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

@MainActor
class ATSViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentJob: JobEntity?
    @Published var cvUploaded: Bool = false

    
    private let getJobUseCase: GetJobByURLUseCase
    private let scoreJobUseCase: ScoreCVAgainstJobUseCase
    private let userRepo: UserDataRepo
    
    init(getJobUseCase: GetJobByURLUseCase, scoreJobUseCase: ScoreCVAgainstJobUseCase, userRepo: UserDataRepo) {
        self.getJobUseCase = getJobUseCase
        self.scoreJobUseCase = scoreJobUseCase
        self.userRepo = userRepo
    }
    
    func fireRequest(jobURL: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
    
        do {
            let result = try await getJobUseCase.execute(jobURL)
            currentJob = result
            return true
        } catch {
            errorMessage = "Couldn't fetch that job posting. Please check the link and try again."
            return false
        }
    }
    
    func scoreCv(workspaceId id: Int) async {
        do {
            let result = try await scoreJobUseCase.execute(id)
            print(result)
        } catch(let error) {
            print("Error is \(error)")
        }
    }
    
    func isCvFound() async {
        do {
            let profile = try await userRepo.getCurrentUser()?.profile
            cvUploaded = !(profile?.cvURL ?? "").isEmpty
            print("Profile : \(profile)")
            print("cvUploaded: \(cvUploaded)")
        } catch(let error) {
            print("Error is \(error)")
        }
    }
    
}
