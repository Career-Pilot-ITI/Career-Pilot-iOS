//
//  ReportsListViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

// ReportsListViewModel.swift
import Foundation

@MainActor
final class ReportsListViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var sessions: [ReportsInterviewSession] = []
    @Published var isRefreshing = false

    private let loadSessionsUseCase: LoadSessionsUseCase
    private let deleteSessionUseCase: DeleteSessionUseCase

    init(
        loadSessionsUseCase: LoadSessionsUseCase,
        deleteSessionUseCase: DeleteSessionUseCase
    ) {
        self.loadSessionsUseCase = loadSessionsUseCase
        self.deleteSessionUseCase = deleteSessionUseCase
    }

    func loadSessions(forceRefresh: Bool = false) async {
        if forceRefresh {
            isRefreshing = true
        } else {
            state = .loading
        }

        do {
            let result = try await loadSessionsUseCase.execute(
                LoadSessionsInput(forceRefresh: forceRefresh)
            )
            sessions = result
            state = result.isEmpty ? .empty : .loaded
        } catch {
            state = .error(error.localizedDescription)
        }

        isRefreshing = false
    }

    func deleteSession(_ session: ReportsInterviewSession) async {
        let previousSessions = sessions
        sessions.removeAll { $0.id == session.id }

        do {
            try await deleteSessionUseCase.execute(session.id)
        } catch {
            sessions = previousSessions
            state = .error(error.localizedDescription)
        }

        if sessions.isEmpty {
            state = .empty
        }
    }
}
