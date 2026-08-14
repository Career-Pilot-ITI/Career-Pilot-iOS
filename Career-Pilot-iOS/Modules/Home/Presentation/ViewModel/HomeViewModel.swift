//  HomeViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    enum HomeState {
        case idle
        case loading
        case success
        case error(String)
    }
    
    // MARK: - Published Properties

    @Published var usedSessions: Double = 1.0
    @Published var totalSessions: Double = 3.0

    @Published private(set) var progressInfo: OverallProgressInfo?
    @Published private(set) var recommendedInterviews: [InterviewItem] = []
    @Published private(set) var recentSessions: [HomeSessionInfo] = []

    @Published private(set) var user: User = .guest

    // MARK: - States
    private var hasLoadedHome = false

    @Published private(set) var userState: HomeState = .idle
    @Published private(set) var tracksState: HomeState = .idle
    @Published private(set) var sessionsState: HomeState = .idle

    // MARK: - Dependencies

    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    private let getAllTracksUseCase: GetAllTrackesUseCase
    private let getAllSessionUseCase: LoadSessionsUseCase
    
    // MARK: - Initialization

    init(
        getCurrentUserUseCase: GetCurrentUserUseCaseProtocol,
        getAllTracksUseCase: GetAllTrackesUseCase,
        getAllSessionUseCase: LoadSessionsUseCase
    ) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.getAllTracksUseCase = getAllTracksUseCase
        self.getAllSessionUseCase = getAllSessionUseCase
    }

    // MARK: - Home

    func loadHome() async {
        guard !hasLoadedHome else { return }
        hasLoadedHome = true

        async let userTask: Void = loadUser()
        async let sessionsTask: Void = loadRecentSessions()
        async let interviewsTask: Void = loadRecommendedInterviews()

        await userTask
        await sessionsTask
        await interviewsTask
    }

    // MARK: - User

    func loadUser() async {

        userState = .loading

        do {
            try await simulateNetworkDelay(seconds:1)
            user = try await getCurrentUserUseCase.execute() ?? .guest
            userState = .success

        } catch is CancellationError {
            return

        } catch {
            userState = .error(error.localizedDescription)
        }
    }

    // MARK: - Recent Sessions

    func loadRecentSessions(forceRefresh: Bool = false) async {
        sessionsState = .loading

        do {
            let result = try await getAllSessionUseCase.execute(LoadSessionsInput(page: 0, forceRefresh: forceRefresh))
            let rawSessions = result.items
            
            let mappedRawSessions = rawSessions
                    .map { ReportsInterviewSession.toHomeSessionInfo(from: $0) }

            self.recentSessions = Array(mappedRawSessions.prefix(5))
            
            self.progressInfo = rawSessions.calculateOverallProgress()
            
            sessionsState = .success

        } catch is CancellationError {
            return

        } catch {
            sessionsState = .error(error.localizedDescription)
        }
    }

    // MARK: - Recommended Interviews

    func loadRecommendedInterviews() async {
        tracksState = .loading

        do {
            let tracks = try await getAllTracksUseCase.execute(())
            
            let mappedItems = tracks.map { $0.toInterviewItem() }
            
            self.recommendedInterviews = Array(mappedItems.prefix(5))
            
            tracksState = .success

        } catch is CancellationError {
            return

        } catch {
            tracksState = .error(error.localizedDescription)
        }
    }

//    // MARK: - Helpers

    private func simulateNetworkDelay(seconds:Int) async throws {
        try await Task.sleep(for: .seconds(seconds))
    }
}
