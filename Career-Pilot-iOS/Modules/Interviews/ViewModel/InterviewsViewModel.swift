//
//  InterviewsViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 09/08/2026.
//

import Foundation
import SwiftUI

enum RecommendedInterviewsViewStates {
    case idle
    case loading
    case success
    case error(String)
}

@MainActor
final class InterviewsViewModel : ObservableObject {
    
    @Published var searchText: String = ""
    @Published var tracksState: RecommendedInterviewsViewStates = .idle

    @Published var interviewsMatchesYourSkills: [InterviewItem] = []
    
    private let getAllTracksUseCase: GetAllTrackesUseCase
    
    init(
        getAllTracksUseCase: GetAllTrackesUseCase
    ) {
        self.getAllTracksUseCase = getAllTracksUseCase
    }
    
    
    func loadRecommendedInterviews() async {
        tracksState = .loading

        do {
            let tracks = try await getAllTracksUseCase.execute(())
            
            let mappedItems = tracks.map { $0.toInterviewItem() }
            
            self.interviewsMatchesYourSkills = mappedItems
            
            self.interviewsMatchesYourSkills.forEach { item in
                print("Loaded interview item: \(item.title) (\(item.level.rawValue))")
            }
            
            tracksState = .success

        } catch is CancellationError {
            return

        } catch {
            tracksState = .error(error.localizedDescription)
        }
    }
    
    var filteredInterviews: [InterviewItem] {
        guard !searchText.isEmpty else {
            return interviewsMatchesYourSkills
        }

        return interviewsMatchesYourSkills.filter { item in
            item.trackInterview.track.title
                .localizedCaseInsensitiveContains(searchText)
        }
    }
}
