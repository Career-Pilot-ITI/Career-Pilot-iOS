//
//  ReportsRepository.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

final class ReportsRepository: ReportsRepositoryProtocol {
    private let remote: ReportsRemoteDataSourceProtocol
    private let local: ReportsLocalDataProtocol

    init(remote: ReportsRemoteDataSourceProtocol, local: ReportsLocalDataProtocol = ReportsLocalDataSource()) {
        self.remote = remote
        self.local = local
    }

    func loadSessions(for userId: Int, forceRefresh: Bool) async throws -> [ReportsInterviewSessionDTO] {
        if !forceRefresh {
            let cached = try await local.fetchSessions(for: userId)
            if !cached.isEmpty { return cached }
        }
        let fresh = try await remote.fetchSessions()
        try await local.saveSessions(fresh, for: userId)
        return fresh
    }

    func loadFeedback(sessionId: Int, forceRefresh: Bool) async throws -> SessionFeedbackDTO {
        if !forceRefresh, let cached = try await local.fetchFeedback(for: sessionId) {
            return cached
        }
        let fresh = try await remote.fetchSessionFeedback(sessionId: sessionId)
        try await local.saveFeedback(fresh, sessionId: sessionId)
        return fresh
    }

    func deleteSession(id: Int) async throws {
        try await local.deleteSession(id: id)
    }

    func deleteAllSessions(for userId: Int) async throws {
        try await local.deleteAllSessions(for: userId)
    }
}
