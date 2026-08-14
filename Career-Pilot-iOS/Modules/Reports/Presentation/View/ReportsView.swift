import SwiftUI

@MainActor
struct ReportsView: View {
    @StateObject private var coordinator = AppCoordinator<ReportsRoute>()
    @StateObject private var viewModel: ReportsListViewModel

    init(viewModel: ReportsListViewModel = DIContainer.shared.container.resolve(ReportsListViewModel.self)!) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            NavigationStack(path: $coordinator.path) {
                content
                    .navigationDestination(for: ReportsRoute.self) { route in
                        destination(for: route)
                    }
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
            VStack(alignment: .leading) {
                Text("Session History")
                    .font(Font.size22Bold)
                    .foregroundStyle(Color.primaryNavy)

                Text("0 sessions · Avg score 0")
                    .font(Font.size14Regular)
                    .foregroundStyle(Color.gray600)
                    .padding(.bottom, 16)
                
                EmptySessionsView()
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
            

        case .error(let message):
            ErrorStateView(message: message) {
                Task { await viewModel.loadSessions(forceRefresh: true) }
            }

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

private struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void
    
    var title: String = "Something went wrong"
    var icon: String = "wifi.exclamationmark"

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Button {
                retryAction()
            } label: {
                Text("Retry")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: 200)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
            .padding(.top, 4)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
