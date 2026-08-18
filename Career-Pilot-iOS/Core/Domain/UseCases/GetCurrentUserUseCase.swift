//
//  GetCurrentUserUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 25/07/2026.
//

protocol GetCurrentUserUseCaseProtocol {
    func execute() async throws -> User?
}

final class GetCurrentUserUseCase: GetCurrentUserUseCaseProtocol {

    private let repository: UserDataRepo

    init(repository: UserDataRepo) {
        self.repository = repository
    }

    func execute() async throws -> User? {
        try await repository.getCurrentUser()
    }
}
