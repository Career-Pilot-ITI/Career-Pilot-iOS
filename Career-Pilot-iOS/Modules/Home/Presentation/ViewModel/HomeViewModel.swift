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
    @Published var userName: String = "Ahmed El-Sayyad Mohamed"
    @Published var userScore: Int = 150
    
    @Published var isLoading = true

    init() {
        loadData()
    }

    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.recentSessions = [
                SessionData(score: 82, title: "Software Eng.", time: "Today, 2:14 PM · 18 min"),
                SessionData(score: 74, title: "Software Eng.", time: "Yesterday, 10:30 AM · 22 min"),
                SessionData(score: 68, title: "System Design", time: "Mon, 9:00 AM · 15 min")
            ]
            self.isLoading = false
        }

    }
}
