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
    var pageMetadata: (totalElements: Int, totalPages: Int, isLast: Bool) = (0, 1, true)
    var feedbackToReturn: SessionFeedbackDTO?
    var shouldThrow = false

    func fetchSessions(page: Int, size: Int) async throws -> PageResponse<ReportsInterviewSessionDTO> {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return makePageResponse(
            content: sessionsToReturn,
            page: page,
            totalElements: pageMetadata.totalElements,
            totalPages: pageMetadata.totalPages,
            isLast: pageMetadata.isLast
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

    // MARK: Helper
    private func makePageResponse(
        content: [ReportsInterviewSessionDTO],
        page: Int,
        totalElements: Int,
        totalPages: Int,
        isLast: Bool
    ) -> PageResponse<ReportsInterviewSessionDTO> {
        let pageable = PageableInfo(paged: true, pageNumber: page, pageSize: 20, unpaged: false, offset: page * 20, sort: SortInfo(sorted: false, unsorted: true, empty: true))
        let sort = SortInfo(sorted: false, unsorted: true, empty: true)
        return PageResponse(
            totalElements: totalElements,
            totalPages: totalPages,
            pageable: pageable,
            last: isLast,
            first: page == 0,
            numberOfElements: content.count,
            size: 20,
            content: content,
            number: page,
            sort: sort,
            empty: totalElements == 0
        )
    }
}

private final class MockLocal: ReportsLocalDataProtocol {
    var cachedSessions: [ReportsInterviewSessionDTO] = []
    var cachedFeedback: SessionFeedbackDTO?
    // Accumulated across all saves (mirrors real upsert-by-id behaviour)
    var savedSessions: [ReportsInterviewSessionDTO] = []
    var savedFeedback: SessionFeedbackDTO?
    var deletedSessionIds: [Int] = []
    var deletedAllForUserId: [Int] = []

    func fetchSessions(for userId: Int) async throws -> [ReportsInterviewSessionDTO] { cachedSessions }
    func fetchFeedback(for sessionId: Int) async throws -> SessionFeedbackDTO? { cachedFeedback }

    func saveSessions(_ sessions: [ReportsInterviewSessionDTO], for userId: Int) async throws {
        // Upsert by id — matches the real implementation's delete-then-insert.
        for session in sessions {
            savedSessions.removeAll { $0.id == session.id }
            savedSessions.append(session)
        }
    }
    func saveFeedback(_ feedback: SessionFeedbackDTO, sessionId: Int) async throws {
        savedFeedback = feedback
    }
    func deleteSession(id: Int) async throws { deletedSessionIds.append(id) }
    func deleteAllSessions(for userId: Int) async throws {
        deletedAllForUserId.append(userId)
        savedSessions.removeAll()
    }
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
        let result = try await sut.loadSessions(for: 1, page: 0, forceRefresh: false)

        // Returns domain entities, not DTOs
        XCTAssertEqual(result.items.map(\.id), [1, 2])
        // Local was used; remote data (id 99) is absent from result
        XCTAssertFalse(result.items.contains { $0.id == 99 })
    }

    func test_loadSessions_whenCacheEmpty_fetchesFromRemoteAndPersists() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 10), makeSessionDTO(id: 11)]
        remote.pageMetadata = (totalElements: 2, totalPages: 1, isLast: true)
        let local = MockLocal()
        // empty cache → falls through to remote

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadSessions(for: 1, page: 0, forceRefresh: false)

        XCTAssertEqual(result.items.map(\.id).sorted(), [10, 11])
        XCTAssertEqual(local.savedSessions.map(\.id).sorted(), [10, 11]) // persisted
    }

    func test_loadSessions_whenForceRefresh_bypassesCacheAndFetchesRemote() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 20)]
        remote.pageMetadata = (totalElements: 1, totalPages: 1, isLast: true)
        let local = MockLocal()
        local.cachedSessions = [makeSessionDTO(id: 1)] // should be bypassed

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadSessions(for: 1, page: 0, forceRefresh: true)

        XCTAssertEqual(result.items.map(\.id), [20])
        // Cache wiped then re-written with new page
        XCTAssertEqual(local.deletedAllForUserId, [1])
        XCTAssertEqual(local.savedSessions.map(\.id), [20])
    }

    func test_loadSessions_returnsEntityType_notDTO() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 1, status: "completed")]
        remote.pageMetadata = (totalElements: 1, totalPages: 1, isLast: true)
        let local = MockLocal()

        let sut = makeSUT(remote: remote, local: local)
        let result = try await sut.loadSessions(for: 1, page: 0, forceRefresh: false)

        // Result is [ReportsInterviewSession] — status enum, not raw String
        XCTAssertEqual(result.items.first?.status, .completed)
    }

    // MARK: Pagination — page > 0 appends to cache

    func test_loadSessions_page1_upsertsMergesIntoCache() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 21), makeSessionDTO(id: 22)]
        remote.pageMetadata = (totalElements: 4, totalPages: 2, isLast: true)
        let local = MockLocal()
        // Simulate page 0 already persisted
        local.savedSessions = [makeSessionDTO(id: 10), makeSessionDTO(id: 11)]

        let sut = makeSUT(remote: remote, local: local)
        _ = try await sut.loadSessions(for: 1, page: 1, forceRefresh: false)

        // Page 0 sessions survive; page 1 sessions are added (upsert)
        let ids = local.savedSessions.map(\.id).sorted()
        XCTAssertEqual(ids, [10, 11, 21, 22])
    }

    func test_loadSessions_forceRefresh_clearsAllThenWritesPage0() async throws {
        let remote = MockRemote()
        remote.sessionsToReturn = [makeSessionDTO(id: 5)]
        remote.pageMetadata = (totalElements: 1, totalPages: 1, isLast: true)
        let local = MockLocal()
        local.savedSessions = [makeSessionDTO(id: 10), makeSessionDTO(id: 11)] // old data

        let sut = makeSUT(remote: remote, local: local)
        _ = try await sut.loadSessions(for: 1, page: 0, forceRefresh: true)

        // Old cache was wiped, then page 0 written
        XCTAssertFalse(local.savedSessions.contains { $0.id == 10 })
        XCTAssertFalse(local.savedSessions.contains { $0.id == 11 })
        XCTAssertTrue(local.savedSessions.contains { $0.id == 5 })
    }

    // MARK: PageResponse decoding — normal page

    func test_pageResponse_decodes_populatedPage() throws {
        let json = """
        {
          "totalElements": 2,
          "totalPages": 1,
          "pageable": {
            "paged": true, "pageNumber": 0, "pageSize": 20,
            "unpaged": false, "offset": 0,
            "sort": {"sorted": false, "unsorted": true, "empty": true}
          },
          "last": true, "first": true, "numberOfElements": 2,
          "size": 20, "number": 0,
          "sort": {"sorted": false, "unsorted": true, "empty": true},
          "empty": false,
          "content": [
            {
              "id": 1, "trackId": 10, "trackName": "iOS",
              "status": "completed", "overallScore": 85.0,
              "durationSeconds": 600, "targetDurationMinutes": 15,
              "maxQuestions": 8,
              "startedAt": "2026-07-01T10:00:00Z",
              "completedAt": "2026-07-01T10:10:00Z",
              "createdAt": "2026-07-01T10:00:00Z"
            },
            {
              "id": 2, "trackId": 10, "trackName": "iOS",
              "status": "abandoned", "overallScore": 42.0,
              "durationSeconds": 300, "targetDurationMinutes": 15,
              "maxQuestions": 8,
              "startedAt": null, "completedAt": null,
              "createdAt": "2026-07-02T10:00:00Z"
            }
          ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let page = try decoder.decode(PageResponse<ReportsInterviewSessionDTO>.self, from: json)

        XCTAssertEqual(page.totalElements, 2)
        XCTAssertEqual(page.content.count, 2)
        XCTAssertFalse(page.empty)
        XCTAssertEqual(page.content[0].id, 1)
        XCTAssertEqual(page.content[1].id, 2)
    }

    // MARK: PageResponse decoding — empty-page edge case

    func test_pageResponse_decodesEmptyPageEdgeCase_withPhantomContentElement() throws {
        // Backend sends `"content": [{}]` and `"empty": true` when there is no data.
        // We must NOT crash and must NOT produce a phantom session entity.
        let json = """
        {
          "totalElements": 0,
          "totalPages": 0,
          "pageable": {
            "paged": true, "pageNumber": 0, "pageSize": 20,
            "unpaged": false, "offset": 0,
            "sort": {"sorted": false, "unsorted": true, "empty": true}
          },
          "last": true, "first": true, "numberOfElements": 0,
          "size": 20, "number": 0,
          "sort": {"sorted": false, "unsorted": true, "empty": true},
          "empty": true,
          "content": [{}]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let page = try decoder.decode(PageResponse<ReportsInterviewSessionDTO>.self, from: json)

        XCTAssertTrue(page.empty, "Server says empty == true")
        XCTAssertEqual(page.content.count, 0, "Phantom element {} must be dropped")
        XCTAssertEqual(page.totalElements, 0)
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
