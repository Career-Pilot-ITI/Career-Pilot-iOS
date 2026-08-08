//
//  TokenRefreshActor.swift
//  Career-Pilot-iOS
//
//  Created by Antigravity on 29/07/2026.
//

import Foundation

actor TokenRefreshActor {

    private var refreshTask: Task<AuthTokens, Error>?

    func refresh(using work: @escaping () async throws -> AuthTokens) async throws -> AuthTokens {
        // If there's already an in-flight refresh, join it.
        if let existing = refreshTask {
            print("🔄 [TOKEN REFRESH] Joining in-flight refresh task")
            return try await existing.value
        }

        // We're first — start a new refresh task.
        print("🔄 [TOKEN REFRESH] Starting new refresh task")
        let task = Task<AuthTokens, Error> { try await work() }
        refreshTask = task

        defer { refreshTask = nil }

        return try await task.value
    }
}
