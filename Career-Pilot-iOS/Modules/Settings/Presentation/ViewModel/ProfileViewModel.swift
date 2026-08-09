//
//  ProfileViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 29/07/2026.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var load: LoadState<UserModelSettingsView> = .idle
    @Published var editableUser: UserModelSettingsView?
    @Published var tracks: [Track]?
    private var userSession : UserSession
    private var originalUser: UserModelSettingsView?
    private var getTracks: GetAllTrackesUseCase
    private let updateUserDataUseCase: UpdateUserData
    private let uploadCvUseCase: UploadCvUseCase
    private let saveUsercase : SaveUserDataUsecase
    private var pendingAvatarData: Data?


    init(
        updateUserDataUseCase: UpdateUserData,
        getTracks: GetAllTrackesUseCase,
        uploadCvUseCase: UploadCvUseCase,
        saveUsercase : SaveUserDataUsecase,
        userSession : UserSession
    ) {
        self.updateUserDataUseCase = updateUserDataUseCase
        self.getTracks = getTracks
        self.uploadCvUseCase = uploadCvUseCase
        self.saveUsercase = saveUsercase
        self.userSession = userSession
    }

    var hasChanges: Bool {
        guard let editableUser, let originalUser else { return false }
        return editableUser != originalUser
    }

    func loadAllScreenData() async {
        await MainActor.run {
            load = .loading
        }
        do {
            async let userDataResponse = userSession.loadIfNeeded()
            async let tracksResponse = getTracks.execute(())

             try await userDataResponse
            let tracks = try await tracksResponse
            guard var user = userSession.userData else {
                load = .failure( NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load tracks"]))
                return
                    }
            user.trackName = tracks.filter { user.trackId == $0.id }.compactMap { $0.title }.first ?? ""

            await MainActor.run {
                originalUser = user
                editableUser = user
                print("user track name is \(user.trackName)")
                self.tracks = tracks
                load = .success(user)
            }

        } catch {
            print("Error loading screen data: \(error)")
            await MainActor.run {
                load = .failure(error)
            }
        }
    }

    func avatarPicked(imageData: Data) {
        pendingAvatarData = imageData
    }

   
    func cvPicked(url: URL) async {
        load = .loading
        do {
            let response = try await uploadCvUseCase.execute(UploadCvRequest(cv: url))
            
            applyCvResponse(response)
            if let editableUser {
                try await saveUsercase.execute(user: editableUser.toUserSettingsDomain())
                load = .success(editableUser)
            }
        } catch {
            load = .failure(error)
            print("The error of analyzing\(error)")
        }
    }

    private func applyCvResponse(_ response: UploadCvResponse) {

        editableUser?.cvUrl = response.userData.cv
        editableUser?.skills = response.userData.skills
        originalUser?.cvUrl = response.userData.cv
        originalUser?.skills = response.userData.skills
        userSession.update(originalUser!)
        
    }

    func updateUserData() async {
        guard var updatedUser = editableUser else { return }
        updatedUser.trackId = tracks?
            .filter { $0.title == updatedUser.trackName }
            .compactMap { $0.id }
            .first ?? 0
        load = .loading
        do {
            let domainUpdate = updatedUser.toUserSettingsDomain()
            try await updateUserDataUseCase.execute(
                imagUrl: pendingAvatarData,
                updateUserProfile: domainUpdate
            )
            editableUser = updatedUser
            originalUser = updatedUser
            userSession.update(domainUpdate.toUserModelSettingsView())
            load = .success(updatedUser)
            
        } catch let validationError as ProfileValidationError {
            load = .failure(validationError)
            
        } catch {
            load = .failure(error)
        }
    }
    
}
