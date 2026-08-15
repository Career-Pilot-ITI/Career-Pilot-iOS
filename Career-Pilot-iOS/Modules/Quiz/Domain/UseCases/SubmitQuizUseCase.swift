//
//  SubmitQuizUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation

struct SubmitQuizUseCase {
    private let repository: QuizRepositoryProtocol
    
    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws {
        try await repository.submitQuiz(
            trackId: trackId,
            subtopicId: subtopicId,
            answers: answers,
            score: score,
            totalQuestions: totalQuestions
        )
    }
}
