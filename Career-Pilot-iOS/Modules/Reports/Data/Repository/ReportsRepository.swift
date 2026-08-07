final class ReportsRepository: ReportsRepositoryProtocol {
    private let remote: ReportsRemoteDataSourceProtocol
    private let local: ReportsLocalDataProtocol

    init(remote: ReportsRemoteDataSourceProtocol, local: ReportsLocalDataProtocol = ReportsLocalDataSource()) {
        self.remote = remote
        self.local = local
    }

    func loadSessions(for userId: Int, page: Int, forceRefresh: Bool) async throws -> PaginatedResult<ReportsInterviewSession> {
        if page == 0 && !forceRefresh {
            let cached = try await local.fetchSessions(for: userId)
            if !cached.isEmpty {
                let info = PaginationInfo(
                    currentPage: 0,
                    totalPages: 1,
                    totalElements: cached.count,
                    isLast: true
                )
                return PaginatedResult(items: cached.map { $0.toDomain() }, pagination: info)
            }
        }

        if forceRefresh && page == 0 {
            try await local.deleteAllSessions(for: userId)
        }

        let pageResponse = try await remote.fetchSessions(page: page, size: ReportsEndpoint.defaultPageSize)

        if !pageResponse.content.isEmpty {
            try await local.saveSessions(pageResponse.content, for: userId)
        }

        return PaginatedResult(
            items: pageResponse.content.map { $0.toDomain() },
            pagination: pageResponse.toPaginationInfo()
        )
    }

    func loadFeedback(sessionId: Int, forceRefresh: Bool) async throws -> SessionFeedback {
        if !forceRefresh, let cached = try await local.fetchFeedback(for: sessionId) {
            return cached.toDomain()
        }
        let fresh = try await remote.fetchSessionFeedback(sessionId: sessionId)
        try await local.saveFeedback(fresh, sessionId: sessionId)
        return fresh.toDomain()
    }

    func deleteSession(id: Int) async throws {
        try await local.deleteSession(id: id)
    }

    func deleteAllSessions(for userId: Int) async throws {
        try await local.deleteAllSessions(for: userId)
    }
}
