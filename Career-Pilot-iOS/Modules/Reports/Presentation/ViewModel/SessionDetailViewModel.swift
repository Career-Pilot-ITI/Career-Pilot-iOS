//
//  SessionDetailViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

@MainActor
final class SessionDetailViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var feedback: SessionFeedback?

    private let loadFeedbackUseCase: LoadSessionFeedbackUseCase
    private let sessionId: Int

    init(
        sessionId: Int,
        loadFeedbackUseCase: LoadSessionFeedbackUseCase
    ) {
        self.sessionId = sessionId
        self.loadFeedbackUseCase = loadFeedbackUseCase
    }

    func loadFeedback(forceRefresh: Bool = false) async {
        state = .loading
        do {
            feedback = try await loadFeedbackUseCase.execute(
                LoadSessionFeedbackInput(sessionId: sessionId, forceRefresh: forceRefresh)
            )
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
