//
//  HomeViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var usedSessions: Double = 1.0
    @Published var totalSessions: Double = 3.0
    
    @Published var recentSessions: [SessionData] = []
    @Published var mockCareerItems: [CareerItem] = []
    
    @Published var user: User?
    
    // state
    @Published var isLoading = true

    // useCases
    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol


    init(getCurrentUserUseCase: GetCurrentUserUseCaseProtocol) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
    }

    @MainActor
    func loadUser() async {
        do {
            user = try await getCurrentUserUseCase.execute()
        } catch {
            print(error)
        }
    }


    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.recentSessions = [
                SessionData(score: 82, title: "Software Eng.", time: "Today, 2:14 PM · 18 min"),
                SessionData(score: 74, title: "Software Eng.", time: "Yesterday, 10:30 AM · 22 min"),
                SessionData(score: 68, title: "System Design", time: "Mon, 9:00 AM · 15 min")
            ]
            
            
            self.mockCareerItems = [
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
            self.isLoading = false
        }

    }
}
