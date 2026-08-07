import Foundation

struct LoadSessionsInput {
    let page: Int
    let forceRefresh: Bool
}

final class LoadSessionsUseCase: UseCase {
    private let repository: ReportsRepositoryProtocol
    private let currentUserProvider: CurrentUserProviding

    init(repository: ReportsRepositoryProtocol, currentUserProvider: CurrentUserProviding) {
        self.repository = repository
        self.currentUserProvider = currentUserProvider
    }

    func execute(_ input: LoadSessionsInput) async throws -> PaginatedResult<ReportsInterviewSession> {
        let userId = try await currentUserProvider.currentUserId()
        return try await repository.loadSessions(for: userId, page: input.page, forceRefresh: input.forceRefresh)
    }
}
