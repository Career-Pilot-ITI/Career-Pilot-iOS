////
////  QuizRepositoryImpl.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
////
//
//import Foundation
//import FirebaseAuth
//
//final class QuizRepositoryImpl: QuizRepositoryProtocol {
//    private let remoteDataSource: QuizRemoteDataSourceProtocol
//    private let aiDataSource: GeminiAIRemoteDataSource
//    
//    init(remoteDataSource: QuizRemoteDataSourceProtocol = FirestoreQuizRemoteDataSource(),
//         aiDataSource: GeminiAIRemoteDataSource = GeminiAIRemoteDataSource()) {
//        self.remoteDataSource = remoteDataSource
//        self.aiDataSource = aiDataSource
//    }
//    
//    func getSubtopics(trackId: String) async throws -> [SubtopicEntity] {
//        if Auth.auth().currentUser == nil {
//            _ = try await Auth.auth().signInAnonymously()
//        }
//        
//        guard let userId = Auth.auth().currentUser?.uid else {
//            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User missing"])
//        }
//        
//        async let subtopicsTask = remoteDataSource.fetchSubtopics(trackId: trackId)
//        async let progressTask = remoteDataSource.fetchUserProgress(userId: userId, trackId: trackId)
//        
//        let (dtos, progressMap) = try await (subtopicsTask, progressTask)
//        
//        return dtos.compactMap { dto in
//            guard let id = dto.id else { return nil }
//            let progress = progressMap[id]
//            return SubtopicEntity(
//                id: id,
//                title: dto.title,
//                order: dto.order,
//                isCompleted: progress?.completed ?? false,
//                score: progress?.score,
//                totalQuestions: progress?.totalQuestions
//            )
//        }
//    }
//    
//    func getQuestions(trackId: String, trackTitle: String, subtopicId: String, subtopicTitle: String) async throws -> [QuestionEntity] {
//        var dtos = try await remoteDataSource.fetchQuestions(trackId: trackId, subtopicId: subtopicId)
//        
//        if dtos.isEmpty {
//            dtos = try await aiDataSource.generateQuestions(trackTitle: trackTitle, subtopicTitle: subtopicTitle)
//            try await remoteDataSource.saveGeneratedQuestions(trackId: trackId, subtopicId: subtopicId, questions: dtos)
//        }
//        
//        return dtos.map {
//            QuestionEntity(
//                id: $0.id ?? UUID().uuidString,
//                questionText: $0.questionText,
//                options: $0.options,
//                correctIndex: $0.correctIndex
//            )
//        }
//    }
//    
//    func submitQuiz(trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User missing"])
//        }
//        
//        try await remoteDataSource.saveQuizAttempt(
//            userId: userId,
//            trackId: trackId,
//            subtopicId: subtopicId,
//            answers: answers,
//            score: score,
//            totalQuestions: totalQuestions
//        )
//    }
//}
//
//  QuizRepositoryImpl.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation
import FirebaseAuth

final class QuizRepositoryImpl: QuizRepositoryProtocol {
    private let remoteDataSource: QuizRemoteDataSourceProtocol
    private let aiDataSource: GeminiAIRemoteDataSource
    
    init(remoteDataSource: QuizRemoteDataSourceProtocol = FirestoreQuizRemoteDataSource(),
         aiDataSource: GeminiAIRemoteDataSource = GeminiAIRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
        self.aiDataSource = aiDataSource
        print("📦 [Repository Init] QuizRepositoryImpl initialized")
    }
    
    func getSubtopics(trackId: String) async throws -> [SubtopicEntity] {
        print("📦 [Repository] getSubtopics called for trackId: '\(trackId)'")
        
        // 1. Auth check
        if Auth.auth().currentUser == nil {
            print("🔑 [Repository Auth] No active user session found. Signing in anonymously...")
            let authResult = try await Auth.auth().signInAnonymously()
            print("🔑 [Repository Auth Success] Signed in anonymously with UID: '\(authResult.user.uid)'")
        } else if let currentUser = Auth.auth().currentUser {
            print("🔑 [Repository Auth] Active session found for UID: '\(currentUser.uid)'")
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ [Repository Auth Error] Auth.auth().currentUser is nil!")
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User missing"])
        }
        
        // 2. Launch concurrent network tasks
        print("🔄 [Repository] Launching parallel tasks: fetchSubtopics & fetchUserProgress...")
        async let subtopicsTask = remoteDataSource.fetchSubtopics(trackId: trackId)
        async let progressTask = remoteDataSource.fetchUserProgress(userId: userId, trackId: trackId)
        
        let (dtos, progressMap) = try await (subtopicsTask, progressTask)
        
        print("📊 [Repository] Fetched \(dtos.count) SubtopicDTO(s) and \(progressMap.count) user progress item(s)")
        
        // 3. Entity Mapping & Nil ID Guard
        var droppedCount = 0
        let mappedEntities = dtos.compactMap { dto -> SubtopicEntity? in
            guard let id = dto.id else {
                droppedCount += 1
                print("⚠️ [Repository Warning] Dropped SubtopicDTO because id is nil! (Title: '\(dto.title)')")
                return nil
            }
            let progress = progressMap[id]
            return SubtopicEntity(
                id: id,
                title: dto.title,
                order: dto.order,
                isCompleted: progress?.completed ?? false,
                score: progress?.score,
                totalQuestions: progress?.totalQuestions
            )
        }
        
        print("📋 [Repository Mapping] Mapped \(mappedEntities.count) valid SubtopicEntity items (Dropped nil IDs: \(droppedCount))")
        return mappedEntities
    }
    
    func getQuestions(trackId: String, trackTitle: String, subtopicId: String, subtopicTitle: String) async throws -> [QuestionEntity] {
        print("📦 [Repository] getQuestions called for subtopicId: '\(subtopicId)' in trackId: '\(trackId)'")
        
        var dtos = try await remoteDataSource.fetchQuestions(trackId: trackId, subtopicId: subtopicId)
        print("📦 [Repository] Firestore returned \(dtos.count) question(s)")
        
        // Fallback to Gemini AI if no questions are stored in Firestore
        if dtos.isEmpty {
            print("🤖 [Repository AI Fallback] No questions found in Firestore. Requesting Gemini AI generation...")
            dtos = try await aiDataSource.generateQuestions(trackTitle: trackTitle, subtopicTitle: subtopicTitle)
            print("🤖 [Repository AI Fallback] Generated \(dtos.count) question(s) via Gemini AI")
            
            print("💾 [Repository Cache] Caching generated questions to Firestore...")
            try await remoteDataSource.saveGeneratedQuestions(trackId: trackId, subtopicId: subtopicId, questions: dtos)
            print("💾 [Repository Cache Success] Questions saved successfully")
        }
        
        return dtos.map {
            QuestionEntity(
                id: $0.id ?? UUID().uuidString,
                questionText: $0.questionText,
                options: $0.options,
                correctIndex: $0.correctIndex
            )
        }
    }
    
    func submitQuiz(trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws {
        print("📦 [Repository] submitQuiz called for subtopicId: '\(subtopicId)' | Score: \(score)/\(totalQuestions)")
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ [Repository Auth Error] Cannot submit quiz - User missing!")
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User missing"])
        }
        
        try await remoteDataSource.saveQuizAttempt(
            userId: userId,
            trackId: trackId,
            subtopicId: subtopicId,
            answers: answers,
            score: score,
            totalQuestions: totalQuestions
        )
        print("✅ [Repository] Quiz attempt saved successfully for userId: '\(userId)'")
    }
    
    func getSubtopics(trackId: String, trackTitle: String) async throws -> [SubtopicEntity] {
        print("📦 [Repository] getSubtopics called for trackId: '\(trackId)' | trackTitle: '\(trackTitle)'")
        
        // 1. Auth check
        if Auth.auth().currentUser == nil {
            print("🔑 [Repository Auth] Signing in anonymously...")
            _ = try await Auth.auth().signInAnonymously()
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User missing"])
        }
        
        // 2. Parallel Fetch
        async let subtopicsTask = remoteDataSource.fetchSubtopics(trackId: trackId)
        async let progressTask = remoteDataSource.fetchUserProgress(userId: userId, trackId: trackId)
        
        var (dtos, progressMap) = try await (subtopicsTask, progressTask)
        
        // 3. 🤖 Fallback: If no subtopics exist in Firestore, generate via Gemini AI!
        if dtos.isEmpty {
            print("🤖 [Repository AI Fallback] No subtopics in Firestore for track '\(trackTitle)'. Generating with Gemini AI...")
            let generatedDTOs = try await aiDataSource.generateSubtopics(trackTitle: trackTitle)
            
            print("💾 [Repository Cache] Saving generated subtopics to Firestore...")
            dtos = try await remoteDataSource.saveGeneratedSubtopics(trackId: trackId, subtopics: generatedDTOs)
        }
        
        // 4. Entity Mapping
        let mappedEntities = dtos.compactMap { dto -> SubtopicEntity? in
            guard let id = dto.id else { return nil }
            let progress = progressMap[id]
            return SubtopicEntity(
                id: id,
                title: dto.title,
                order: dto.order,
                isCompleted: progress?.completed ?? false,
                score: progress?.score,
                totalQuestions: progress?.totalQuestions
            )
        }
        
        print("📋 [Repository Success] Returning \(mappedEntities.count) subtopic entity/entities")
        return mappedEntities
    }
}
