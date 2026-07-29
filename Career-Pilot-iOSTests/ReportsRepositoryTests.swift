//
//  ReportsRepositoryTests.swift
//  Career-Pilot-iOSTests
//
//  Created by Antigravity on 29/07/2026.
//

import XCTest
@testable import Career_Pilot_iOS

// MARK: - Mocks

private final class MockRemote: ReportsRemoteDataSourceProtocol {
    var sessionsToReturn: [ReportsInterviewSessionDTO] = []
    var feedbackToReturn: SessionFeedbackDTO?
    var shouldThrow = false

    func fetchSessions() async throws -> ReportsInterviewSessionResponseDTO {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return ReportsInterviewSessionResponseDTO(
            message: "ok", success: true, timestamp: "", data: sessionsToReturn
        )
    }

    func fetchSessionDetail(sessionId: Int) async throws -> ReportsInterviewSessionDTO {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return sessionsToReturn.first ?? makeSessionDTO(id: sessionId)
    }

    func fetchSessionQuestions(sessionId: Int) async throws -> [SessionQuestionDTO] { [] }

    func fetchQuestionDetail(sessionId: Int, questionId: Int) async throws -> SessionQuestionDTO {
        makeQuestionDTO(id: questionId, sessionId: sessionId)
    }

    func fetchSessionFeedback(sessionId: Int) async throws -> SessionFeedbackDTO {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return feedbackToReturn ?? makeFeedbackDTO(sessionId: sessionId)
    }
}

private final class MockLocal: ReportsLocalDataProtocol {
    var cachedSessions: [ReportsInterviewSessionDTO] = []
    var cachedFeedback: SessionFeedbackDTO?
    var savedSessions: [ReportsInterviewSessionDTO] = []
    var savedFeedback: SessionFeedbackDTO?
    var deletedSessionIds: [Int] = []
    var deletedAllForUserId: [Int] = []

    func fetchSessions(for userId: Int) async throws -> [ReportsInterviewSessionDTO] { cachedSessions }
    func fetchFeedback(for sessionId: Int) async throws -> SessionFeedbackDTO? { cachedFeedback }

    func saveSessions(_ sessions: [ReportsInterviewSessionDTO], for userId: Int) async throws {
        savedSessions = sessions
    }
    func saveFeedback(_ feedback: SessionFeedbackDTO, sessionId: Int) async throws {
        savedFeedback = feedback
    }
    func deleteSession(id: Int) async throws { deletedSessionIds.append(id) }
    func deleteAllSessions(for userId: Int) async throws { deletedAllForUserId.append(userId) }
}

// MARK: - Tests

final class ReportsRepositoryTests: XCTestCase {

    // MARK: loadSessions — cache-first behaviour

    func test_loadSessions_whenCacheNonEmpty_returnsCachedEntitiesWithoutNetworkCall() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 99)] // should NOT be called
        let local = MockLocal()
        local.cachedSessions = [makeSessionDTO(id: 1), makeSessionDTO(id: 2)]

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadSessions(for: 1, forceRefresh: false)

        // Returns domain entities, not DTOs
        XCTAssertEqual(result.map(\.id), [1, 2])
        // Local was used; remote data (id 99) is absent from result
        XCTAssertFalse(result.contains { $0.id == 99 })
    }

    func test_loadSessions_whenCacheEmpty_fetchesFromRemoteAndPersists() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 10), makeSessionDTO(id: 11)]
        let local = MockLocal()
        // empty cache → falls through to remote

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadSessions(for: 1, forceRefresh: false)

        XCTAssertEqual(result.map(\.id).sorted(), [10, 11])
        XCTAssertEqual(local.savedSessions.map(\.id).sorted(), [10, 11]) // persisted
    }

    func test_loadSessions_whenForceRefresh_bypassesCacheAndFetchesRemote() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 20)]
        let local = MockLocal()
        local.cachedSessions = [makeSessionDTO(id: 1)] // should be bypassed

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadSessions(for: 1, forceRefresh: true)

        XCTAssertEqual(result.map(\.id), [20])
        XCTAssertEqual(local.savedSessions.map(\.id), [20])
    }

    func test_loadSessions_returnsEntityType_notDTO() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 1, status: "completed")]
        let local = MockLocal()

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadSessions(for: 1, forceRefresh: false)

        // Result is [ReportsInterviewSession] — status enum, not raw String
        XCTAssertEqual(result.first?.status, .completed)
    }

    // MARK: loadFeedback — cache-first behaviour

    func test_loadFeedback_whenCacheExists_returnsCachedEntity() async throws {
        let remote = MockRemote()
        remote.feedbackToReturn = makeFeedbackDTO(sessionId: 99, overallScore: 50) // should NOT be called
        let local = MockLocal()
        local.cachedFeedback = makeFeedbackDTO(sessionId: 3, overallScore: 88)

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadFeedback(sessionId: 3, forceRefresh: false)

        XCTAssertEqual(result.overallScore, 88)
        XCTAssertNil(local.savedFeedback) // remote was not called → nothing new saved
    }

    func test_loadFeedback_whenNoCacheAndForceRefresh_fetchesRemoteAndPersists() async throws {
        let remote = MockRemote()
        remote.feedbackToReturn = makeFeedbackDTO(sessionId: 5, overallScore: 77)
        let local = MockLocal()

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadFeedback(sessionId: 5, forceRefresh: true)

        XCTAssertEqual(result.overallScore, 77)
        XCTAssertEqual(local.savedFeedback?.sessionId, 5) // persisted DTO
    }

    func test_loadFeedback_returnsEntityType_notDTO() async throws {
        let remote = MockRemote()
        remote.feedbackToReturn = makeFeedbackDTO(sessionId: 1, overallScore: 82)
        let local = MockLocal()

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadFeedback(sessionId: 1, forceRefresh: false)

        // Should be SessionFeedback domain entity, with coachingTips as [String]
        XCTAssertEqual(result.coachingTips, ["Be concise"])
    }

    // MARK: deleteSession / deleteAllSessions

    func test_deleteSession_delegatesToLocal() async throws {
        let local = MockLocal()
        let sut = makeSUT(remote: MockRemote(), local: local)
        try await sut.deleteSession(id: 42)
        XCTAssertEqual(local.deletedSessionIds, [42])
    }

    func test_deleteAllSessions_delegatesToLocal() async throws {
        let local = MockLocal()
        let sut = makeSUT(remote: MockRemote(), local: local)
        try await sut.deleteAllSessions(for: 7)
        XCTAssertEqual(local.deletedAllForUserId, [7])
    }

    // MARK: - Helpers

    private func makeSUT(remote: ReportsRemoteDataSourceProtocol,
                         local: ReportsLocalDataProtocol) -> ReportsRepositoryProtocol {
        ReportsRepository(remote: remote, local: local)
    }

    private func makeSessionDTO(id: Int, status: String = "completed") -> ReportsInterviewSessionDTO {
        ReportsInterviewSessionDTO(
            id: id, trackId: 1, trackName: "iOS",
            status: status, overallScore: 80,
            durationSeconds: 600, targetDurationMinutes: 15,
            maxQuestions: 5,
            startedAt: Date(timeIntervalSince1970: 0),
            completedAt: Date(timeIntervalSince1970: 600),
            createdAt: Date(timeIntervalSince1970: 0)
        )
    }

    private func makeQuestionDTO(id: Int, sessionId: Int) -> SessionQuestionDTO {
        SessionQuestionDTO(
            id: id, sessionId: sessionId, questionText: "Q\(id)", questionOrder: 1,
            userTranscript: "", durationMs: 30000, speechRateWpm: 130,
            avgPauseMs: 250, silenceRatio: 0.1, createdAt: Date(), completedAt: nil, score: nil
        )
    }

    private func makeFeedbackDTO(sessionId: Int, overallScore: Double = 80) -> SessionFeedbackDTO {
        SessionFeedbackDTO(
            id: sessionId * 10, sessionId: sessionId,
            overallScore: overallScore,
            clarityScore: 78, confidenceScore: 85,
            pacingScore: 72, fillerWordsScore: 66, contentRelevanceScore: 88,
            coachingTips: ["Be concise"],
            generatedAt: Date(timeIntervalSince1970: 0),
            createdAt: Date(timeIntervalSince1970: 0),
            questions: []
        )
    }
}
