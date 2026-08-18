import Foundation

protocol ReportsRepositoryProtocol {
    func loadSessions(for userId: Int, page: Int, forceRefresh: Bool) async throws -> PaginatedResult<ReportsInterviewSession>
    func loadFeedback(sessionId: Int, forceRefresh: Bool) async throws -> SessionFeedback
    func deleteSession(id: Int) async throws
    func deleteAllSessions(for userId: Int) async throws
}
