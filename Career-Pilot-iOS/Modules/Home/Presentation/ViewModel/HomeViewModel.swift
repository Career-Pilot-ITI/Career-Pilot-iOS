//  HomeViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation

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
    @Published private(set) var recommendedInterviews: [CareerItem] = []

    @Published private(set) var user: User = .guest

    // MARK: - States
    private var hasLoadedHome = false

    @Published private(set) var userState: HomeState = .idle
    @Published private(set) var tracksState: HomeState = .idle
    @Published private(set) var sessionsState: HomeState = .idle

    // MARK: - Dependencies

    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol

    // MARK: - Initialization

    init(
        getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    ) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
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
            try await simulateNetworkDelay(seconds:2)

            recommendedInterviews = [
                CareerItem(
                    iconName: "bolt.fill",
                    title: "React Deep Dive",
                    tagText: "Matches: React",
                    durationText: "~15 min"
                ),
                CareerItem(
                    iconName: "swift",
                    title: "SwiftUI Architecture",
                    tagText: "Matches: iOS",
                    durationText: "~20 min"
                ),
                CareerItem(
                    iconName: "server.rack",
                    title: "Node.js Microservices",
                    tagText: "Matches: Backend",
                    durationText: "~30 min"
                ),
                CareerItem(
                    iconName: "paintbrush.fill",
                    title: "Design Systems 101",
                    tagText: "Matches: UI/UX",
                    durationText: "~10 min"
                )
            ]

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
