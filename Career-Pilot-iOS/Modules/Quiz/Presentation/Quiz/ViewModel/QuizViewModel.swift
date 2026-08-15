//
//  QuizViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation
import SwiftUI

@MainActor
final class QuizViewModel: ObservableObject {
    let trackId: String
    let trackTitle: String
    let subtopicId: String
    let subtopicTitle: String
    
    @Published var questions: [QuestionEntity] = []
    @Published var currentIndex = 0
    @Published var selectedAnswers: [Int?] = []
    @Published var isLoading = false
    @Published var isSubmitting = false
    @Published var isCompleted = false
    @Published var finalScore = 0
    @Published var errorMessage: String?
    
    private let repository: QuizRepositoryProtocol
    private let submitQuizUseCase: SubmitQuizUseCase
    
    init(trackId: String, trackTitle: String, subtopicId: String, subtopicTitle: String, repository: QuizRepositoryProtocol = QuizRepositoryImpl()) {
        self.trackId = trackId
        self.trackTitle = trackTitle
        self.subtopicId = subtopicId
        self.subtopicTitle = subtopicTitle
        self.repository = repository
        self.submitQuizUseCase = SubmitQuizUseCase(repository: repository)
    }
    
    func loadQuestions() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await repository.getQuestions(
                trackId: trackId,
                trackTitle: trackTitle,
                subtopicId: subtopicId,
                subtopicTitle: subtopicTitle
            )
            self.questions = fetched
            self.selectedAnswers = Array(repeating: nil, count: fetched.count)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func selectAnswer(index: Int) {
        guard currentIndex < selectedAnswers.count else { return }
        selectedAnswers[currentIndex] = index
    }
    
    func submit() async {
        isSubmitting = true
        var score = 0
        let answers = selectedAnswers.compactMap { $0 }
        
        for (idx, q) in questions.enumerated() {
            if idx < selectedAnswers.count, selectedAnswers[idx] == q.correctIndex {
                score += 1
            }
        }
        self.finalScore = score
        
        do {
            try await submitQuizUseCase.execute(
                trackId: trackId,
                subtopicId: subtopicId,
                answers: answers,
                score: score,
                totalQuestions: questions.count
            )
            self.isCompleted = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isSubmitting = false
    }
}
