//  HomeViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation
import SwiftUI

enum HomeState {
    case idle
    case loading
    case success
    case error(String)
}

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var usedSessions: Double = 1.0
    @Published var totalSessions: Double = 3.0

    @Published private(set) var recentSessions: [SessionData] = []
    @Published private(set) var recommendedInterviews: [InterviewItem] = []

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

    func loadRecentSessions() async {
        sessionsState = .loading

        do {
            try await simulateNetworkDelay(seconds:2)
            try await getAllSessionUseCase.execute(<#T##input: LoadSessionsInput##LoadSessionsInput#>)
            recentSessions = [
                SessionData(
                    score: 82,
                    title: "Software Eng.",
                    time: "Today, 2:14 PM · 18 min"
                ),
                SessionData(
                    score: 74,
                    title: "Software Eng.",
                    time: "Yesterday, 10:30 AM · 22 min"
                ),
                SessionData(
                    score: 68,
                    title: "System Design",
                    time: "Mon, 9:00 AM · 15 min"
                )
            ]

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
            
            self.recommendedInterviews = mappedItems
            
            self.recommendedInterviews.forEach { item in
                print("Loaded interview item: \(item.title) (\(item.level.rawValue))")
            }
            
            tracksState = .success

        } catch is CancellationError {
            return

        } catch {
            tracksState = .error(error.localizedDescription)
        }
    }

    // MARK: - Helpers

    private func simulateNetworkDelay(seconds:Int) async throws {
        try await Task.sleep(for: .seconds(seconds))
    }
}
