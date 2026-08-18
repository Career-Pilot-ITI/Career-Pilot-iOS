import Foundation

@MainActor
final class ReportsListViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loadingMore
        case loaded
        case empty
        case error(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var sessions: [ReportsInterviewSession] = []
    @Published private(set) var pagination: PaginationInfo?
    @Published var isRefreshing = false

    private let loadSessionsUseCase: LoadSessionsUseCase
    private let deleteSessionUseCase: DeleteSessionUseCase
    private var currentPage: Int = -1

    init(
        loadSessionsUseCase: LoadSessionsUseCase,
        deleteSessionUseCase: DeleteSessionUseCase
    ) {
        self.loadSessionsUseCase = loadSessionsUseCase
        self.deleteSessionUseCase = deleteSessionUseCase
    }

    func loadSessions(forceRefresh: Bool = false) async {
        guard state != .loading else { return }

        if forceRefresh {
            isRefreshing = true
        } else {
            state = .loading
        }

        await fetchPage(0, forceRefresh: forceRefresh, appending: false)
        isRefreshing = false
    }

    func loadNextPage() async {
        guard let pagination = pagination, pagination.hasMore else { return }
        guard state != .loadingMore, state != .loading else { return }

        state = .loadingMore
        await fetchPage(currentPage + 1, forceRefresh: false, appending: true)
    }

    func deleteSession(_ session: ReportsInterviewSession) async {
        let previousSessions = sessions
        sessions.removeAll { $0.id == session.id }

        do {
            try await deleteSessionUseCase.execute(session.id)
        } catch {
            sessions = previousSessions
            state = .error(error.localizedDescription)
            return
        }

        if sessions.isEmpty {
            state = .empty
        }
    }

    private func fetchPage(_ page: Int, forceRefresh: Bool, appending: Bool) async {
        do {
            let result = try await loadSessionsUseCase.execute(
                LoadSessionsInput(page: page, forceRefresh: forceRefresh)
            )

            let serverIsEmpty = result.pagination.totalElements == 0

            if appending {
                sessions += result.items
            } else {
                sessions = result.items
            }

            pagination = result.pagination
            currentPage = page

            state = serverIsEmpty ? .empty : .loaded

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
