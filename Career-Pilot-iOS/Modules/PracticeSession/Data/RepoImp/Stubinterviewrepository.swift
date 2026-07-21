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

    func submitAnswer(
        sessionId: String,
        questionId: String,
        audioReference: AudioReference,
        duration: TimeInterval
    ) async throws -> SubmitAnswerOutcome {
        try await simulateDelay()
        askedCount += 1
        // Figure out how many questions have already been asked by finding the
        // matching stub question's index, so the stub can decide whether to hand
        // back another question or wrap up. A real backend would track this server-side.
//       askedCount = (stubQuestions.firstIndex { $0.hashValue.description == questionId } ?? 0) + 1

        print("Asked Q is \(askedCount)")
        throw InterviewError.questionLimitReached
        
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

    func resumeInterview(sessionId: String) async throws -> InterviewSession {
        try await simulateDelay()

        // The stub has no real persistence, so it just hands back a fresh in-progress
        // session on the same id — good enough for exercising the reconnect UI path.
        let question = InterviewQuestion(id: UUID().uuidString, text: stubQuestions[0], order: 0)
        return InterviewSession(
            id: sessionId,
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

    func finishInterview(sessionId: String) async throws -> InterviewFeedback {
        try await simulateDelay()
        return try Self.stubFeedback()
    }

    func cancelInterview(sessionId: String) async throws {
        try await simulateDelay()
    }

    private func simulateDelay() async throws {
        try await Task.sleep(nanoseconds: simulatedNetworkDelay)
    }

    private static func stubFeedback() throws -> InterviewFeedback {
        throw InterviewError.networkUnavailable
        InterviewFeedback(
            overallScore: 8.2,
            communicationScore: 8.5,
            technicalScore: 7.9,
            strengths: ["Clear structure", "Good use of concrete examples"],
            weaknesses: ["Could go deeper on trade-offs"],
            recommendations: ["Practice quantifying impact with numbers"]
        )
    }
}
