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
    private var originalUser: UserModelSettingsView?
    private var getTracks: GetAllTrackesUseCase
    private let getUserDataUseCase: GetUserDataUseCase
    private let updateUserDataUseCase: UpdateUserData
    private let uploadCvUseCase: UploadCvUseCase
    private let saveUsercase : SaveUserDataUsecase
    private var pendingAvatarData: Data?

    init(
        getUserDataUseCase: GetUserDataUseCase,
        updateUserDataUseCase: UpdateUserData,
        getTracks: GetAllTrackesUseCase,
        uploadCvUseCase: UploadCvUseCase,
        saveUsercase : SaveUserDataUsecase
    ) {
        self.getUserDataUseCase = getUserDataUseCase
        self.updateUserDataUseCase = updateUserDataUseCase
        self.getTracks = getTracks
        self.uploadCvUseCase = uploadCvUseCase
        self.saveUsercase = saveUsercase
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
            async let userDataResponse = getUserDataUseCase.execute()
            async let tracksResponse = getTracks.execute(())

            var user = try await userDataResponse
            let tracks = try await tracksResponse
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
    }

    func updateUserData() async {
        load = .loading

        do {
            try await updateUserDataUseCase.execute(
                imagUrl: pendingAvatarData,
                updateUserProfile: (editableUser?.toUserSettingsDomain())!
            )
            originalUser = editableUser

            load = .success(originalUser!)
        } catch {
            print(error)
        }
    }
}
