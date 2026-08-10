import SwiftUI

@MainActor
struct ReportsView: View {
    @StateObject private var coordinator = AppCoordinator<ReportsRoute>()
    @StateObject private var viewModel: ReportsListViewModel

    init(viewModel: ReportsListViewModel = DIContainer.shared.container.resolve(ReportsListViewModel.self)!) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: ReportsRoute.self) { route in
                    destination(for: route)
                }
        }
        .environmentObject(coordinator)
        .task {
            await viewModel.loadSessions()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            Text("No sessions yet")
                .foregroundStyle(Color.gray600)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            VStack(spacing: 12) {
                Text(message).foregroundStyle(.red)
                Button("Retry") { Task { await viewModel.loadSessions(forceRefresh: true) } }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            sessionHistoryView(isLoadingMore: false)

        case .loadingMore:
            sessionHistoryView(isLoadingMore: true)
        }
    }

    @ViewBuilder
    private func sessionHistoryView(isLoadingMore: Bool) -> some View {
        VStack(spacing: 0) {
            SessionHistory(
                sessionCount: viewModel.pagination?.totalElements ?? viewModel.sessions.count,
                sessionAvgScore: {
                    let scores = viewModel.sessions.compactMap(\.overallScore)
                    return scores.isEmpty ? 0 : scores.reduce(0, +) / Double(scores.count)
                }(),
                sessions: viewModel.sessions.map { $0.toUIModel() },
                hasMore: viewModel.pagination?.hasMore ?? false,
                onLoadMore: { Task { await viewModel.loadNextPage() } }
            )
            if isLoadingMore {
                ProgressView()
                    .padding(.bottom, 12)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: ReportsRoute) -> some View {
        switch route {
        case .sessionDetail(let sessionId):
            SessionView(
                sessionId: sessionId,
                viewModel: DIContainer.shared.container.resolve(SessionDetailViewModel.self, argument: sessionId)!
            )
        case .questionBreakdown(let sessionId):
            QuestionBreakdownView(
                viewModel: DIContainer.shared.container.resolve(SessionDetailViewModel.self, argument: sessionId)!
            )
        }
    }
}
