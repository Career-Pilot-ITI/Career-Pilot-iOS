//
//  AccountSettingsViewMdoel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var loadState: LoadState<UserModelSettingsView> = .idle
    private let logout : LogoutUsecase
    private let userSession : UserSession
    init(userSession : UserSession ,logout : LogoutUsecase) {
        self.userSession = userSession
        self.logout = logout
    }
    
    func load() async throws {
        do{
            loadState  = .loading
            try await userSession.loadIfNeeded()
            guard var user = userSession.userData else{
                loadState = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load tracks"]));                return
            }
            print("The user data is \(user.fullName)")
            loadState = .success(user)
            
        }catch{
            loadState  = .failure(error)
            
            print("The error in the view to fetch user\(error)")
            throw error
        }
    }
    func logout(appState : AppState) async   {
        
        do {
            try await logout.execute()
            appState.logout()
        }catch{
            print("This is error \(error)")
        }
    }
    
}
