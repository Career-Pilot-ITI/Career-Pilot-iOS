////
////  File.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
////
//
//import Foundation
//import SwiftUI
//
//@MainActor
//final class PathLearnViewModel: ObservableObject {
//    let trackId: String
//    let trackTitle: String
//    
//    @Published var subtopics: [SubtopicEntity] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private let getSubtopicsUseCase: GetSubtopicsWithProgressUseCase
//    
//    init(trackId: String, trackTitle: String, getSubtopicsUseCase: GetSubtopicsWithProgressUseCase = GetSubtopicsWithProgressUseCase(repository: QuizRepositoryImpl())) {
//        self.trackId = trackId
//        self.trackTitle = trackTitle
//        self.getSubtopicsUseCase = getSubtopicsUseCase
//    }
//    
//    func fetchSubtopics() async {
//        isLoading = true
//        errorMessage = nil
//        do {
//            self.subtopics = try await getSubtopicsUseCase.execute(trackId: trackId)
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//        isLoading = false
//    }
//}
//
//  PathLearnViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 14/08/2026.
//

import Foundation
import SwiftUI

@MainActor
final class PathLearnViewModel: ObservableObject {
    let trackId: String
    let trackTitle: String
    
    @Published var subtopics: [SubtopicEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getSubtopicsUseCase: GetSubtopicsWithProgressUseCase
    
    init(
        trackId: String,
        trackTitle: String,
        getSubtopicsUseCase: GetSubtopicsWithProgressUseCase = GetSubtopicsWithProgressUseCase(repository: QuizRepositoryImpl())
    ) {
        self.trackId = trackId
        self.trackTitle = trackTitle
        self.getSubtopicsUseCase = getSubtopicsUseCase
        print("🔍 [ViewModel Init] Initialized PathLearnViewModel | trackId: '\(trackId)' | trackTitle: '\(trackTitle)'")
    }
    
    func fetchSubtopics() async {
        print("🚀 [ViewModel] Starting fetchSubtopics() for trackId: '\(trackId)'...")
        isLoading = true
        errorMessage = nil
        
        do {
            self.subtopics = try await getSubtopicsUseCase.execute(trackId: trackId, trackTitle: trackTitle)
            print("✅ [ViewModel Success] Loaded \(self.subtopics.count) subtopics")
        } catch {
            print("❌ [ViewModel Error] \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
