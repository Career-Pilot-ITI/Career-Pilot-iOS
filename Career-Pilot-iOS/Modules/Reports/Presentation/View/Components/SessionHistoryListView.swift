//
//  SessionHistoryListView.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 19/07/2026.
//
import SwiftUI

struct SessionHistoryListView: View {
    @EnvironmentObject var coordinator: AppCoordinator<ReportsRoute>
    let sessions: [Session]

    var body: some View {
        VStack(spacing: Spacing.s12) {
            ForEach(sessions) { session in
                SessionHistroyItem(session: session)
                    .onTapGesture {
                        coordinator.push(.sessionDetail(sessionId: session.id))
                    }
            }
        }
    }
}

