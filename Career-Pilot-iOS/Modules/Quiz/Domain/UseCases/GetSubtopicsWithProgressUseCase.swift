////
////  File.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
////
//
//import Foundation
//
//struct GetSubtopicsWithProgressUseCase {
//    private let repository: QuizRepositoryProtocol
//    
//    init(repository: QuizRepositoryProtocol) {
//        self.repository = repository
//    }
//    
//    func execute(trackId: String) async throws -> [SubtopicEntity] {
//        try await repository.getSubtopics(trackId: trackId)
//    }
//}
//
//  GetSubtopicsWithProgressUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation

struct GetSubtopicsWithProgressUseCase {
    private let repository: QuizRepositoryProtocol
    
    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
        print("⚙️ [UseCase Init] GetSubtopicsWithProgressUseCase initialized")
    }
    
    func execute(trackId: String, trackTitle: String) async throws -> [SubtopicEntity] {
        try await repository.getSubtopics(trackId: trackId, trackTitle: trackTitle)
    }
}
