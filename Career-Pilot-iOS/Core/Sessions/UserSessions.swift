//
//  UserSessions.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

//import Foundation
//@MainActor
//final class UserSession: ObservableObject {
//    @Published var userData: UserData?
//    
//    private let getUserDataUseCase: GetUserDataUseCase
//    private let updateUserDataUseCase: UpdateUserDataUseCase
//    
//    init(getUserDataUseCase: GetUserDataUseCase, updateUserDataUseCase: UpdateUserDataUseCase) {
//        self.getUserDataUseCase = getUserDataUseCase
//        self.updateUserDataUseCase = updateUserDataUseCase
//    }
//    
//    func loadUserData() async {
//        do {
//            userData = try await getUserDataUseCase.execute()
//        } catch {
//            print("Failed to load user data: \(error)")
//        }
//    }
//    
//    func updateUserData(_ newData: UserData) async throws {
//        try await updateUserDataUseCase.execute(newData)
//        userData = newData
//    }
//}
