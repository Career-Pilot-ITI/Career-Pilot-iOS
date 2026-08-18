//
//  File.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation

protocol QuizRepositoryProtocol {
    func getSubtopics(trackId: String) async throws -> [SubtopicEntity]
    func getQuestions(trackId: String, trackTitle: String, subtopicId: String, subtopicTitle: String) async throws -> [QuestionEntity]
    func submitQuiz(trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws
    func getSubtopics(trackId: String, trackTitle: String) async throws -> [SubtopicEntity]
}
