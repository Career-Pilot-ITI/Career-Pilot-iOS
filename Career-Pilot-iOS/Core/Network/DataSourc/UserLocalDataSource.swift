//
//  OnboardingLocalDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 22/07/2026.
//
//
//  UserLocalDataSource.swift
//  Career-Pilot-iOS
//

import CoreData

protocol UserLocalDataSource {
    func saveUser(_ user: User) async throws -> Bool
    func getUser() async throws -> User?
    func deleteUser() async throws
}

final class UserLocalDataSourceImpl: UserLocalDataSource {

    private let coreData: CoreDataManaging

    init(coreData: CoreDataManaging) {
        self.coreData = coreData
    }

    func saveUser(_ user: User) async throws -> Bool {

        try await coreData.performBackgroundTask { context in

            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

            let users = try context.fetch(request)

            users.forEach(context.delete)

            user.toEntity(in: context)

            let verifyRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            let count = try context.count(for: verifyRequest)

            return count > 0
        }
    }

    func getUser() async throws -> User? {

        try await coreData.performViewContextTask { context in

            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

            guard let entity = try context.fetch(request).first else {
                return nil
            }

            return try entity.toDomain()
        }
    }

    func deleteUser() async throws {

        try await coreData.performBackgroundTask { context in

            let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

            let users = try context.fetch(request)

            users.forEach(context.delete)
        }
    }
}
