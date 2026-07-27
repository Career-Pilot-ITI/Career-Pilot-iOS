//
//  AccountSettingsViewMdoel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
@MainActor
final class SettingsViewModel: ObservableObject {
    private let getUserData : GetUserDataUseCase
    private let userLogout : LogoutUsecase
    @Published var loadState: LoadState<UserModelSettingsView> = .idle
    init(getUserData: GetUserDataUseCase , userLogout : LogoutUsecase) {
        self.getUserData = getUserData
        self.userLogout = userLogout
    }
    
    func load() async throws {
        do{
            loadState  = .loading
            let user = try await getUserData.execute()
            loadState = .success(user)
            
        }catch{
            loadState  = .failure(error)

            print("The error in the view to fetch user\(error)")
            throw error
        }
    }
    func logout(appState : AppState) async   {
         
        do {
            try await userLogout.execute()
            appState.logout()
        }catch{
            print("This is error \(error)")
        }
    }
}
