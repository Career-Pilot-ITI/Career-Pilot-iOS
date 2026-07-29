//
//  HomeViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: Published Properties

    @Published var usedSessions: Double = 1.0
    @Published var totalSessions: Double = 3.0

    @Published var microphoneEnabled = false
    @Published var showSettingsAlert = false
    @Published var showOpenSettingsConfirmation = false
    
    @Published var recentSessions: [SessionData] = []
    @Published var mockCareerItems: [CareerItem] = []

    @Published var user: User = User.guest

    @Published var isLoading = true

    // MARK: Dependencies

    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    private let permissionManager: MicrophonePermissionManaging

    // MARK: Init

    init(
        getCurrentUserUseCase: GetCurrentUserUseCaseProtocol,
        permissionManger: MicrophonePermissionManaging
    ) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.permissionManager = permissionManger
    }

    // MARK: Permission

    func onAppear() {
        refreshMicrophonePermission()
    }

    func refreshMicrophonePermission() {
        microphoneEnabled = permissionManager.permissionStatus() == .granted
    }

    func microphoneToggleChanged(_ enabled: Bool) {

        if enabled {

            switch permissionManager.permissionStatus() {

            case .granted:
                microphoneEnabled = true

            case .undetermined:

                permissionManager.requestPermission { [weak self] granted in
                    guard let self else { return }

                    Task { @MainActor in
                        self.microphoneEnabled = granted

                        if !granted {
                            self.showSettingsAlert = true
                        }
                    }
                }

            case .denied:
                microphoneEnabled = false
                showSettingsAlert = true

            @unknown default:
                microphoneEnabled = false
            }

        } else {
            
            showOpenSettingsConfirmation = true

            microphoneEnabled = true
        }
    }

    // MARK: User

    func loadUser() async {
        do {
            user = try await getCurrentUserUseCase.execute()
        } catch {
            print(error)
        }
    }

    // MARK: Mock Data

    func loadData() {

        Task {
            try? await Task.sleep(for: .seconds(2))

            recentSessions = [
                SessionData(score: 82, title: "Software Eng.", time: "Today, 2:14 PM · 18 min"),
                SessionData(score: 74, title: "Software Eng.", time: "Yesterday, 10:30 AM · 22 min"),
                SessionData(score: 68, title: "System Design", time: "Mon, 9:00 AM · 15 min")
            ]

            mockCareerItems = [
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

            isLoading = false
        }
    }
}
