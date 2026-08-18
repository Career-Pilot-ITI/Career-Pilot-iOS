//
//  SaveUserData.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 22/07/2026.
//

import Foundation

final class SaveUserUseCase: UseCase {

    typealias Input = User
    typealias Output = Void

    private let userRepository: UserDataRepo

    init(userRepository: UserDataRepo) {
        self.userRepository = userRepository
    }

    func execute(_ input: User) async throws {
        _ = try await save(input)
    }

    func save(_ input: User) async throws -> Bool {
        try await userRepository.saveUser(input)
    }
}
