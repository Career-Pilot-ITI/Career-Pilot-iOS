//
//  TokenRefreshActor.swift
//  Career-Pilot-iOS
//
//  Created by Antigravity on 29/07/2026.
//

import Foundation

/// A Swift actor that serialises token-refresh calls and deduplicates
/// concurrent requests so only ONE network refresh is ever in-flight
/// at a time.
///
/// Any caller that arrives while a refresh is already running will
/// `await` the existing `Task` and share its result — they never
/// trigger a second refresh.
actor TokenRefreshActor {

    private var refreshTask: Task<AuthTokens, Error>?

    /// Perform a refresh, or join an already in-flight one.
    ///
    /// - Parameter work: The async closure that calls the refresh
    ///   endpoint and returns fresh `AuthTokens`. Called at most once
    ///   per "refresh window."
    /// - Returns: The new `AuthTokens` from either this call or the
    ///   shared in-flight task.
    /// - Throws: Rethrows whatever `work` throws (e.g. network errors).
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

        // Always clear the task slot when done so the next expiry
        // triggers a fresh refresh rather than re-using a completed task.
        defer { refreshTask = nil }

        return try await task.value
    }
}
