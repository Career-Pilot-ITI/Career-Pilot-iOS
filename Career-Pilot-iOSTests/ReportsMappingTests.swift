//
//  ReportsMappingTests.swift
//  Career-Pilot-iOSTests
//
//  Created by Antigravity on 29/07/2026.
//

import XCTest
@testable import Career_Pilot_iOS

final class ReportsMappingTests: XCTestCase {

    // MARK: - QuestionScoreDTO → QuestionScore

    func test_questionScoreDTO_toDomain_mapsAllFields() {
        let dto = QuestionScoreDTO(
            id: 1,
            sessionQuestionId: 10,
            contentRelevance: 80.0,
            clarity: 75.0,
            confidence: 90.0,
            pacing: 70.0,
            fillerWords: 65.0,
            overallScore: 76.0,
            coachingTip: "Slow down a little.",
            createdAt: Date(timeIntervalSince1970: 0)
        )

        let entity = dto.toDomain()

        XCTAssertEqual(entity.id, 1)
        XCTAssertEqual(entity.sessionQuestionId, 10)
        XCTAssertEqual(entity.contentRelevance, 80.0)
        XCTAssertEqual(entity.clarity, 75.0)
        XCTAssertEqual(entity.confidence, 90.0)
        XCTAssertEqual(entity.pacing, 70.0)
        XCTAssertEqual(entity.fillerWords, 65.0)
        XCTAssertEqual(entity.overallScore, 76.0)
        XCTAssertEqual(entity.coachingTip, "Slow down a little.")
        XCTAssertEqual(entity.createdAt, Date(timeIntervalSince1970: 0))
    }

    // MARK: - SessionQuestionDTO → SessionQuestion

    func test_sessionQuestionDTO_toDomain_withScore_mapsAllFields() {
        let scoreDTO = QuestionScoreDTO(
            id: 5, sessionQuestionId: 42,
            contentRelevance: 80, clarity: 82, confidence: 78,
            pacing: 74, fillerWords: 60, overallScore: 74.8,
            coachingTip: "Great job", createdAt: Date(timeIntervalSince1970: 100)
        )
        let dto = SessionQuestionDTO(
            id: 42,
            sessionId: 7,
            questionText: "Tell me about yourself.",
            questionOrder: 1,
            userTranscript: "So, um, I have been...",
            durationMs: 62000,
            speechRateWpm: 140.0,
            avgPauseMs: 320.0,
            silenceRatio: 0.12,
            createdAt: Date(timeIntervalSince1970: 200),
            completedAt: Date(timeIntervalSince1970: 262),
            score: scoreDTO
        )

        let entity = dto.toDomain()

        XCTAssertEqual(entity.id, 42)
        XCTAssertEqual(entity.sessionId, 7)
        XCTAssertEqual(entity.questionText, "Tell me about yourself.")
        XCTAssertEqual(entity.questionOrder, 1)
        XCTAssertEqual(entity.userTranscript, "So, um, I have been...")
        XCTAssertEqual(entity.durationMs, 62000)
        XCTAssertEqual(entity.speechRateWpm, 140.0)
        XCTAssertNotNil(entity.score)
        XCTAssertEqual(entity.score?.overallScore, 74.8)
        XCTAssertEqual(entity.score?.coachingTip, "Great job")
    }

    func test_sessionQuestionDTO_toDomain_withoutScore_scoreIsNil() {
        let dto = SessionQuestionDTO(
            id: 1, sessionId: 1, questionText: "Q1", questionOrder: 1,
            userTranscript: "", durationMs: 0, speechRateWpm: 0,
            avgPauseMs: 0, silenceRatio: 0,
            createdAt: Date(), completedAt: nil, score: nil
        )

        XCTAssertNil(dto.toDomain().score)
    }

    // MARK: - ReportsInterviewSessionDTO → ReportsInterviewSession

    func test_interviewSessionDTO_toDomain_completedStatus() {
        let dto = makeSessionDTO(status: "completed")
        let entity = dto.toDomain()
        XCTAssertEqual(entity.status, .completed)
        XCTAssertEqual(entity.id, 99)
        XCTAssertEqual(entity.trackName, "iOS Engineering")
    }

    func test_interviewSessionDTO_toDomain_unknownStatus_usesUnknownCase() {
        let dto = makeSessionDTO(status: "paused")
        XCTAssertEqual(dto.toDomain().status, .unknown("paused"))
    }

    func test_interviewSessionDTO_toDomain_inProgressStatus() {
        XCTAssertEqual(makeSessionDTO(status: "in_progress").toDomain().status, .inProgress)
    }

    func test_interviewSessionDTO_toDomain_abandonedStatus() {
        XCTAssertEqual(makeSessionDTO(status: "abandoned").toDomain().status, .abandoned)
    }

    // MARK: - SessionFeedbackDTO → SessionFeedback

    func test_feedbackDTO_toDomain_mapsQuestionsRecursively() {
        let questionDTO = SessionQuestionDTO(
            id: 1, sessionId: 3, questionText: "Q?", questionOrder: 1,
            userTranscript: "Answer", durationMs: 30000, speechRateWpm: 120,
            avgPauseMs: 200, silenceRatio: 0.1,
            createdAt: Date(), completedAt: nil, score: nil
        )
        let dto = SessionFeedbackDTO(
            id: 7, sessionId: 3,
            overallScore: 81, clarityScore: 78, confidenceScore: 85,
            pacingScore: 72, fillerWordsScore: 66, contentRelevanceScore: 88,
            coachingTips: ["Tip 1", "Tip 2"],
            generatedAt: Date(timeIntervalSince1970: 500),
            createdAt: Date(timeIntervalSince1970: 501),
            questions: [questionDTO]
        )

        let entity = dto.toDomain()

        XCTAssertEqual(entity.id, 7)
        XCTAssertEqual(entity.sessionId, 3)
        XCTAssertEqual(entity.overallScore, 81)
        XCTAssertEqual(entity.coachingTips, ["Tip 1", "Tip 2"])
        XCTAssertEqual(entity.questions.count, 1)
        XCTAssertEqual(entity.questions[0].id, 1)
        XCTAssertEqual(entity.questions[0].questionText, "Q?")
    }

    // MARK: - Helpers

    private func makeSessionDTO(status: String) -> ReportsInterviewSessionDTO {
        ReportsInterviewSessionDTO(
            id: 99, trackId: 1,
            trackName: "iOS Engineering",
            status: status,
            overallScore: 82.0,
            durationSeconds: 1080,
            targetDurationMinutes: 20,
            maxQuestions: 8,
            startedAt: Date(timeIntervalSince1970: 0),
            completedAt: Date(timeIntervalSince1970: 1080),
            createdAt: Date(timeIntervalSince1970: 0)
        )
    }
}
