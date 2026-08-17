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
    private let refreshUseCase: RefreshUserDataUseCase
    
    init(getUserDataUseCase: GetUserDataUseCase, refreshUseCase: RefreshUserDataUseCase) {
        self.getUserDataUseCase = getUserDataUseCase
        self.refreshUseCase = refreshUseCase
    }
    
    func loadIfNeeded() async throws {
        guard userData == nil else { return }
        
        let domainData = try await getUserDataUseCase.execute()
        self.userData = domainData
    }
    
    func reload() async throws {
        let domainData = try await refreshUseCase.execute()
      
        self.userData = domainData.toUserModelSettingsView()
    }
    
    func update(_ newData: UserModelSettingsView) {
        print("🟢 UserSession UPDATE")
        print("Session ID:", ObjectIdentifier(self))
        userData = newData
    }
}
