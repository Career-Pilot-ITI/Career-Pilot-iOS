//
//  CurrentUserProvider.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

protocol CurrentUserProviding {
    func currentUserId() async throws -> Int
}

final class CurrentUserProvider: CurrentUserProviding {
    private let coreDataManager: CoreDataManaging
    init(coreDataManager: CoreDataManaging = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }

    func currentUserId() async throws -> Int {
        try await coreDataManager.performViewContextTask { context in
            let request = UserEntity.fetchRequest()
            request.fetchLimit = 1
            guard let user = try context.fetch(request).first else {
                throw LocalStoreError.missingProfile
            }
            return Int(user.id)
        }
    }
}
