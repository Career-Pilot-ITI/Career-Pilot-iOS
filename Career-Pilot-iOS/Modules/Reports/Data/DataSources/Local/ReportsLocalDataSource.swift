//
//  ReportsLocalDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import CoreData

protocol ReportsLocalDataProtocol {
    func saveSessions(_ sessions: [ReportsInterviewSessionDTO], for userId: Int) async throws
    func fetchSessions(for userId: Int) async throws -> [ReportsInterviewSessionDTO]
    func saveFeedback(_ feedback: SessionFeedbackDTO, sessionId: Int) async throws
    func fetchFeedback(for sessionId: Int) async throws -> SessionFeedbackDTO?
    func deleteSession(id: Int) async throws
    func deleteAllSessions(for userId: Int) async throws
}

final class ReportsLocalDataSource: ReportsLocalDataProtocol {
    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }

    func saveSessions(_ sessions: [ReportsInterviewSessionDTO], for userId: Int) async throws {
        try await coreDataManager.performBackgroundTask { context in
            let userRequest = UserEntity.fetchRequest()
            userRequest.predicate = NSPredicate(format: "id == %d", userId)
            guard let user = try context.fetch(userRequest).first else {
                throw LocalStoreError.missingProfile // or a dedicated .missingUser error
            }

            for dto in sessions {
                let sessionRequest = InterviewSessionEntity.fetchRequest()
                sessionRequest.predicate = NSPredicate(format: "id == %d", dto.id)
                if let existing = try context.fetch(sessionRequest).first {
                    context.delete(existing) // simplest: replace, avoids manual field-by-field diffing
                }
                dto.toEntity(in: context, user: user)
            }
        }
    }

    func fetchSessions(for userId: Int) async throws -> [ReportsInterviewSessionDTO] {
        try await coreDataManager.performBackgroundTask { context in
            let request = InterviewSessionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "user.id == %d", userId)
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            return try context.fetch(request).map { $0.toDTO() }
        }
    }

    func saveFeedback(_ feedback: SessionFeedbackDTO, sessionId: Int) async throws {
        try await coreDataManager.performBackgroundTask { context in
            let sessionRequest = InterviewSessionEntity.fetchRequest()
            sessionRequest.predicate = NSPredicate(format: "id == %d", sessionId)
            guard let session = try context.fetch(sessionRequest).first else {
                throw LocalStoreError.missingProfile
            }
            if let existingFeedback = session.feedback {
                context.delete(existingFeedback)
            }
            feedback.toEntity(in: context, session: session)
        }
    }

    func fetchFeedback(for sessionId: Int) async throws -> SessionFeedbackDTO? {
        try await coreDataManager.performBackgroundTask { context in
            let request = SessionFeedbackEntity.fetchRequest()
            request.predicate = NSPredicate(format: "sessionId == %d", sessionId)
            return try context.fetch(request).first?.toDTO()
        }
    }

    func deleteSession(id: Int) async throws {
        try await coreDataManager.performBackgroundTask { context in
            let request = InterviewSessionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            let results = try context.fetch(request)
            results.forEach(context.delete)
        }
    }

    func deleteAllSessions(for userId: Int) async throws {
        try await coreDataManager.performBackgroundTask { context in
            let request = InterviewSessionEntity.fetchRequest()
            request.predicate = NSPredicate(format: "user.id == %d", userId)
            let results = try context.fetch(request)
            results.forEach(context.delete)
        }
    }
}
