//
//  AccountSettingsViewMdoel.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var loadState: LoadState<UserModelSettingsView> = .idle
    private let logout: LogoutUsecase
    private let userSession: UserSession
    private var cancellables = Set<AnyCancellable>()
    init(
        userSession: UserSession,
        logout: LogoutUsecase
    ) {
        self.userSession = userSession
        self.logout = logout

        // Listen to future changes
        userSession.$userData
            .compactMap { $0 }
            .sink { [weak self] user in
                print("🔵 Settings received user:", user as Any)
                         print(
                             "🔵 Settings Session ID:",
                             ObjectIdentifier(userSession)
                         )
                self?.loadState = .success(user)
            }
            .store(in: &cancellables)
    }

    func load() async {
        loadState = .loading

        do {
            try await userSession.loadIfNeeded()

            // Return the current user through loadState
            guard let user = userSession.userData else {
                return
            }

            loadState = .success(user)

        } catch {
            loadState = .failure(error)
        }
    }

    func logout(appState: AppState) async {
        do {
            try await logout.execute()
            appState.logout()
            userSession.userData = nil 
        } catch {
            print("Logout error: \(error)")
        }
    }
}
