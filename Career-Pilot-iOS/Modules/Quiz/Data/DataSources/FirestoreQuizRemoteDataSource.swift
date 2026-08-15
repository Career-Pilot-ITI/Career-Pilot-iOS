////
////  FirestoreQuizRemoteDataSource.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
////
//
//import Foundation
//import FirebaseFirestore
//
//protocol QuizRemoteDataSourceProtocol {
//    func fetchSubtopics(trackId: String) async throws -> [SubtopicDTO]
//    func fetchUserProgress(userId: String, trackId: String) async throws -> [String: SubtopicProgressDTO]
//    func fetchQuestions(trackId: String, subtopicId: String) async throws -> [QuizQuestionDTO]
//    func saveGeneratedQuestions(trackId: String, subtopicId: String, questions: [QuizQuestionDTO]) async throws
//    func saveQuizAttempt(userId: String, trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws
//}
//
//final class FirestoreQuizRemoteDataSource: QuizRemoteDataSourceProtocol {
//    private let db = Firestore.firestore()
//    
//    func fetchSubtopics(trackId: String) async throws -> [SubtopicDTO] {
//        let snapshot = try await db.collection("tracks")
//            .document(trackId)
//            .collection("subtopics")
//            .order(by: "order")
//            .getDocuments()
//        return snapshot.documents.compactMap { try? $0.data(as: SubtopicDTO.self) }
//    }
//    
//    func fetchUserProgress(userId: String, trackId: String) async throws -> [String: SubtopicProgressDTO] {
//        let snapshot = try await db.collection("users")
//            .document(userId)
//            .collection("progress")
//            .document(trackId)
//            .collection("subtopics")
//            .getDocuments()
//        
//        var map: [String: SubtopicProgressDTO] = [:]
//        for doc in snapshot.documents {
//            if let progress = try? doc.data(as: SubtopicProgressDTO.self) {
//                map[doc.documentID] = progress
//            }
//        }
//        return map
//    }
//    
//    func fetchQuestions(trackId: String, subtopicId: String) async throws -> [QuizQuestionDTO] {
//        let snapshot = try await db.collection("tracks")
//            .document(trackId)
//            .collection("subtopics")
//            .document(subtopicId)
//            .collection("questions")
//            .getDocuments()
//        return snapshot.documents.compactMap { try? $0.data(as: QuizQuestionDTO.self) }
//    }
//    
//    func saveGeneratedQuestions(trackId: String, subtopicId: String, questions: [QuizQuestionDTO]) async throws {
//        let batch = db.batch()
//        let ref = db.collection("tracks")
//            .document(trackId)
//            .collection("subtopics")
//            .document(subtopicId)
//            .collection("questions")
//        
//        for q in questions {
//            let docRef = ref.document()
//            var dto = q
//            dto.id = docRef.documentID
//            try batch.setData(from: dto, forDocument: docRef)
//        }
//        
//        try await batch.commit()
//    }
//    
//    func saveQuizAttempt(userId: String, trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws {
//        let backendUserId = UserDefaults.standard.string(forKey: "backend_user_id") ?? ""
//        
//        let attemptData: [String: Any] = [
//            "backendUserId": backendUserId,
//            "topicId": trackId,
//            "subtopicId": subtopicId,
//            "answers": answers,
//            "score": score,
//            "totalQuestions": totalQuestions,
//            "submittedAt": FieldValue.serverTimestamp()
//        ]
//        
//        _ = try await db.collection("users")
//            .document(userId)
//            .collection("attempts")
//            .addDocument(data: attemptData)
//            
//        let progressData: [String: Any] = [
//            "backendUserId": backendUserId,
//            "completed": true,
//            "score": score,
//            "totalQuestions": totalQuestions,
//            "completedAt": FieldValue.serverTimestamp()
//        ]
//        
//        try await db.collection("users")
//            .document(userId)
//            .collection("progress")
//            .document(trackId)
//            .collection("subtopics")
//            .document(subtopicId)
//            .setData(progressData, merge: true)
//    }
//}
//
//  FirestoreQuizRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation
import FirebaseFirestore

protocol QuizRemoteDataSourceProtocol {
    func fetchSubtopics(trackId: String) async throws -> [SubtopicDTO]
    func fetchUserProgress(userId: String, trackId: String) async throws -> [String: SubtopicProgressDTO]
    func fetchQuestions(trackId: String, subtopicId: String) async throws -> [QuizQuestionDTO]
    func saveGeneratedQuestions(trackId: String, subtopicId: String, questions: [QuizQuestionDTO]) async throws
    func saveQuizAttempt(userId: String, trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws
    func saveGeneratedSubtopics(trackId: String, subtopics: [SubtopicDTO]) async throws -> [SubtopicDTO]
}

final class FirestoreQuizRemoteDataSource: QuizRemoteDataSourceProtocol {
    private let db = Firestore.firestore()
    
    init() {
        print("🔥 [FirestoreDS Init] FirestoreQuizRemoteDataSource initialized")
    }
    
    func fetchSubtopics(trackId: String) async throws -> [SubtopicDTO] {
        let path = "tracks/\(trackId)/subtopics"
        print("🔥 [FirestoreDS] Fetching subtopics from path: '\(path)'...")
        
        let snapshot = try await db.collection("tracks")
            .document(trackId)
            .collection("subtopics")
            .order(by: "order")
            .getDocuments()
        
        print("🔥 [FirestoreDS] Received \(snapshot.documents.count) document(s) for subtopics")
        
        let subtopics: [SubtopicDTO] = snapshot.documents.compactMap { doc in
            print("   ├─ Doc ID: '\(doc.documentID)' | Raw Data: \(doc.data())")
            var dto = try? doc.data(as: SubtopicDTO.self)
            
            // Fallback: Ensure DTO ID is explicitly set if @DocumentID didn't capture it
            if dto?.id == nil {
                print("   │  ⚠️ dto.id was nil! Assigning doc.documentID ('\(doc.documentID)') to DTO")
                dto?.id = doc.documentID
            }
            return dto
        }
        
        print("🔥 [FirestoreDS Success] Successfully decoded \(subtopics.count) SubtopicDTO(s)")
        return subtopics
    }
    
    func fetchUserProgress(userId: String, trackId: String) async throws -> [String: SubtopicProgressDTO] {
        let path = "users/\(userId)/progress/\(trackId)/subtopics"
        print("🔥 [FirestoreDS] Fetching user progress from path: '\(path)'...")
        
        let snapshot = try await db.collection("users")
            .document(userId)
            .collection("progress")
            .document(trackId)
            .collection("subtopics")
            .getDocuments()
        
        print("🔥 [FirestoreDS] Received \(snapshot.documents.count) progress document(s)")
        
        var map: [String: SubtopicProgressDTO] = [:]
        for doc in snapshot.documents {
            if let progress = try? doc.data(as: SubtopicProgressDTO.self) {
                map[doc.documentID] = progress
                print("   ├─ Subtopic '\(doc.documentID)': Completed = \(progress.completed ?? false), Score = \(progress.score ?? 0)")
            } else {
                print("   ⚠️ Failed to decode SubtopicProgressDTO for doc ID: '\(doc.documentID)'")
            }
        }
        
        print("🔥 [FirestoreDS Success] Constructed progress map with \(map.count) entry/entries")
        return map
    }
    
    func fetchQuestions(trackId: String, subtopicId: String) async throws -> [QuizQuestionDTO] {
        let path = "tracks/\(trackId)/subtopics/\(subtopicId)/questions"
        print("🔥 [FirestoreDS] Fetching questions from path: '\(path)'...")
        
        let snapshot = try await db.collection("tracks")
            .document(trackId)
            .collection("subtopics")
            .document(subtopicId)
            .collection("questions")
            .getDocuments()
        
        print("🔥 [FirestoreDS] Received \(snapshot.documents.count) document(s) for questions")
        
        let questions: [QuizQuestionDTO] = snapshot.documents.compactMap { doc in
            var dto = try? doc.data(as: QuizQuestionDTO.self)
            if dto?.id == nil {
                dto?.id = doc.documentID
            }
            return dto
        }
        
        print("🔥 [FirestoreDS Success] Successfully decoded \(questions.count) QuizQuestionDTO(s)")
        return questions
    }
    
    func saveGeneratedQuestions(trackId: String, subtopicId: String, questions: [QuizQuestionDTO]) async throws {
        let path = "tracks/\(trackId)/subtopics/\(subtopicId)/questions"
        print("🔥 [FirestoreDS Batch] Saving \(questions.count) generated question(s) to path: '\(path)'...")
        
        let batch = db.batch()
        let ref = db.collection("tracks")
            .document(trackId)
            .collection("subtopics")
            .document(subtopicId)
            .collection("questions")
        
        for q in questions {
            let docRef = ref.document()
            var dto = q
            dto.id = docRef.documentID
            try batch.setData(from: dto, forDocument: docRef)
            print("   ├─ Queued question write with Generated Doc ID: '\(docRef.documentID)'")
        }
        
        try await batch.commit()
        print("🔥 [FirestoreDS Batch Success] Committed batch write for \(questions.count) questions")
    }
    
    func saveQuizAttempt(userId: String, trackId: String, subtopicId: String, answers: [Int], score: Int, totalQuestions: Int) async throws {
        let backendUserId = UserDefaults.standard.string(forKey: "backend_user_id") ?? ""
        print("🔥 [FirestoreDS] Saving quiz attempt for userId: '\(userId)' | backendUserId: '\(backendUserId)'")
        
        let attemptData: [String: Any] = [
            "backendUserId": backendUserId,
            "topicId": trackId,
            "subtopicId": subtopicId,
            "answers": answers,
            "score": score,
            "totalQuestions": totalQuestions,
            "submittedAt": FieldValue.serverTimestamp()
        ]
        
        let attemptRef = try await db.collection("users")
            .document(userId)
            .collection("attempts")
            .addDocument(data: attemptData)
        print("🔥 [FirestoreDS] Added quiz attempt record with ID: '\(attemptRef.documentID)'")
        
        let progressData: [String: Any] = [
            "backendUserId": backendUserId,
            "completed": true,
            "score": score,
            "totalQuestions": totalQuestions,
            "completedAt": FieldValue.serverTimestamp()
        ]
        
        let progressPath = "users/\(userId)/progress/\(trackId)/subtopics/\(subtopicId)"
        print("🔥 [FirestoreDS] Updating user progress at path: '\(progressPath)'...")
        
        try await db.collection("users")
            .document(userId)
            .collection("progress")
            .document(trackId)
            .collection("subtopics")
            .document(subtopicId)
            .setData(progressData, merge: true)
        
        print("🔥 [FirestoreDS Success] Saved quiz attempt and progress successfully")
    }
    
    func saveGeneratedSubtopics(trackId: String, subtopics: [SubtopicDTO]) async throws -> [SubtopicDTO] {
        let path = "tracks/\(trackId)/subtopics"
        print("🔥 [FirestoreDS Batch] Saving \(subtopics.count) generated subtopic(s) to path: '\(path)'...")
        
        let batch = db.batch()
        let collectionRef = db.collection("tracks").document(trackId).collection("subtopics")
        
        var savedDTOs: [SubtopicDTO] = []
        
        for item in subtopics {
            let docRef = collectionRef.document()
            var dto = item
            dto.id = docRef.documentID
            try batch.setData(from: dto, forDocument: docRef)
            savedDTOs.append(dto)
            print("   ├─ Queued Subtopic: '\(dto.title)' with ID: '\(docRef.documentID)'")
        }
        
        try await batch.commit()
        print("🔥 [FirestoreDS Batch Success] Committed \(savedDTOs.count) subtopic(s) to Firestore")
        return savedDTOs
    }
}
