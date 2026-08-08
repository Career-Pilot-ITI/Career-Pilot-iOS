//
//  UserSessions.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation

@MainActor
final class UserSession: ObservableObject {
    @Published var userData: UserModelSettingsView?
    
    private let getUserDataUseCase: GetUserDataUseCase
    private let refreshUseCase : RefreshUserDataUseCase
    
    init(getUserDataUseCase: GetUserDataUseCase,refreshUseCase : RefreshUserDataUseCase) {
        self.getUserDataUseCase = getUserDataUseCase
        self.refreshUseCase = refreshUseCase
    }
    
    func loadIfNeeded() async throws {
        guard userData == nil else { return }
        userData = try await getUserDataUseCase.execute()
    }
    
    func reload() async throws {
        try await refreshUseCase.execute()
        userData = try await getUserDataUseCase.execute()
    }
    
    func update(_ newData: UserModelSettingsView) {
        userData = newData
    }
}
