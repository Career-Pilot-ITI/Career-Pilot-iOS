//
//  GetAllTrackesUseCase.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

final class GetAllTrackesUseCase: UseCase{
    
    typealias Output = [Track]
    var onBordingRepo: OnBordingRepo
    
    init(onBordingRepo: OnBordingRepo) {
        self.onBordingRepo = onBordingRepo
    }
    
    
    func execute(_ input: Void) async throws -> [Track] {
        return try await onBordingRepo.getAllTracks()
    }
}
