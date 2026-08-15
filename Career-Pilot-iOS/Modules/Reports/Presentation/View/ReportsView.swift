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
            ReportsHistorySkeletonView()

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
                sessionAvgScore: viewModel.sessions.map(\.overallScore).reduce(0, +) / Double(max(viewModel.sessions.count, 1)),
                sessions: viewModel.sessions.map { $0.toUIModel() },
                hasMore: viewModel.pagination?.hasMore ?? false,
                onLoadMore: { Task { await viewModel.loadNextPage() } }
            )
            if isLoadingMore {
                ReportsLoadMoreSkeletonView()
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

private struct ReportsHistorySkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonPill(width: 160, height: 24)
            SkeletonPill(width: 150, height: 16)
                .padding(.top, 8)
                .padding(.bottom, 16)
            ScrollView {
                VStack(spacing: Spacing.s12) {
                    ForEach(0..<4, id: \.self) { _ in
                        ReportsSessionRowSkeletonView()
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
    }
}

private struct ReportsSessionRowSkeletonView: View {
    var body: some View {
        HStack(spacing: Spacing.s12) {
            SkeletonPill(width: 44, height: 36)
            VStack(alignment: .leading, spacing: Spacing.s8) {
                SkeletonPill(width: 150, height: 16)
                SkeletonPill(width: 190, height: 12)
            }
            Spacer()
            SkeletonPill(width: 18, height: 18)
        }
        .padding(16)
        .background(Color.gray400.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Radius.r16, style: .continuous))
    }
}

private struct ReportsLoadMoreSkeletonView: View {
    var body: some View {
        SkeletonBlock(height: 44, cornerRadius: Radius.r12)
            .padding(.top, 8)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
    }
}
