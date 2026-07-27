//
//  ReportsRepositoryProtocol.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 26/07/2026.
//

import Foundation

protocol ReportsRepositoryProtocol {
    func loadSessions(for userId: Int, forceRefresh: Bool) async throws -> [ReportsInterviewSessionDTO]
    func loadFeedback(sessionId: Int, forceRefresh: Bool) async throws -> SessionFeedbackDTO
    func deleteSession(id: Int) async throws
    func deleteAllSessions(for userId: Int) async throws
}
