//
//  StubInterviewRepository.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 20/07/2026.
//

import Foundation

/// Simulates the backend in memory so the whole practice-session flow can run
/// end-to-end before real endpoints exist. Swap this out for InterviewRepositoryImpl
/// once the APIEndpoint shapes are confirmed — nothing else in the app needs to change,
/// since everything upstream only knows about the InterviewRepository protocol.
final class StubInterviewRepository: InterviewRepository, @unchecked Sendable {

    private var askedCount = 0

    private let simulatedNetworkDelay: UInt64 = 500_000_000 // 0.5s, in nanoseconds
    private let stubQuestions: [String] = [
        "Tell me about a time you had to design a system that needed to scale to millions of users. What were the key trade-offs you considered?",
        "Describe a situation where you disagreed with a technical decision. How did you handle it?",
        "Walk me through how you'd debug a production issue you've never seen before.",
        "Tell me about a project that didn't go as planned. What did you learn?"
    ]

    func startInterview(configuration: InterviewConfiguration) async throws -> InterviewSession {
        try await simulateDelay()

        let firstQuestion = InterviewQuestion(
            id: UUID().uuidString,
            text: stubQuestions[0],
            order: 0
        )

        return InterviewSession(
            id: UUID().uuidString,
            status: .aiAsking,
            currentQuestionIndex: 0,
            questions: [firstQuestion],
            answers: [],
            configuration: configuration,
            feedback: nil
        )
    }

    func resumeInterview(session: InterviewSession) async throws -> InterviewSession {
        try await simulateDelay()

        // The stub has no real persistence, so it just hands back a fresh in-progress
        // session on the same id — good enough for exercising the reconnect UI path.
        let question = InterviewQuestion(id: UUID().uuidString, text: stubQuestions[0], order: 0)
        return InterviewSession(
            id: session.id,
            status: .aiAsking,
            currentQuestionIndex: 0,
            questions: [question],
            answers: [],
            configuration: InterviewConfiguration(
                maxQuestions: 3,
                maxAnswerDuration: 240,
                maxInterviewDuration: 1800,
                silenceTimeout: 5,
                trackID: 1
            ),
            feedback: nil
        )
    }

    func finishInterview(finishInterviewRequest: FinishInterviewRequest) async throws -> InterviewFeedback {
        try await simulateDelay()
        return try Self.stubFeedback()
    }

    func cancelInterview(sessionId: String) async throws {
        try await simulateDelay()
    }

    private func simulateDelay() async throws {
        try await Task.sleep(nanoseconds: simulatedNetworkDelay)
    }

    private static func stubFeedback() -> InterviewFeedback {
        InterviewFeedback(
            overallScore: 82,
            clarityScore: 85,
            confidenceScore: 80,
            pacingScore: 78,
            fillerWordsScore: 88,
            contentRelevanceScore: 81,
            coachingTips: [
                "Keep supporting your answers with real examples.",
                "Maintain a steady speaking pace.",
                "Continue reducing filler words."
            ],
            questions: [
                InterviewFeedbackQuestion(
                    question: "Tell me about yourself.",
                    transcript: "I'm an iOS developer with experience building apps using SwiftUI and Clean Architecture.",
                    durationMs: 90000,
                    speechRateWpm: 135,
                    silenceRatio: 0.12,
                    score: InterviewQuestionScore(
                        overall: 84,
                        clarity: 86,
                        confidence: 82,
                        pacing: 80,
                        fillerWords: 90,
                        contentRelevance: 83,
                        coachingTip: "Add more measurable achievements."
                    )
                ),
                InterviewFeedbackQuestion(
                    question: "Explain dependency injection.",
                    transcript: "Dependency injection is a design pattern that helps reduce coupling between components...",
                    durationMs: 110000,
                    speechRateWpm: 140,
                    silenceRatio: 0.09,
                    score: InterviewQuestionScore(
                        overall: 80,
                        clarity: 81,
                        confidence: 79,
                        pacing: 76,
                        fillerWords: 86,
                        contentRelevance: 82,
                        coachingTip: "Mention constructor injection before other approaches."
                    )
                )
            ]
        )
    }

    // MARK: Submit Answer
    func submitAnswer(submitAnswerRequest: SubmitAnswerRequest) async throws -> SubmitAnswerOutcome {

        /// Tasks
        /// convert to text
        /// make sure if it is the last q -> complete Not -> cont
        ///

        let speechService = SpeechRecognitionService()
        var audioAsText: String = "No text yes"

        switch submitAnswerRequest.audioReference {
        case .localFile(let url), .remoteURL(let url):
            audioAsText = try await speechService.transcribe(audioAt: url)
        }

        print("Audio As Text: \(audioAsText)")

        try await simulateDelay()
        askedCount += 1

        print("Asked Q is \(askedCount)")
//        throw InterviewError.questionLimitReached

        if askedCount >= 3 {
            return .interviewCompleted(try Self.stubFeedback())
        }

        let nextQuestion = InterviewQuestion(
            id: UUID().uuidString,
            text: stubQuestions[askedCount % stubQuestions.count],
            order: askedCount
        )
        return .nextQuestion(nextQuestion)
    }
}
