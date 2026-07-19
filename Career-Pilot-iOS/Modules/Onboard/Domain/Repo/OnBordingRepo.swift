//
//  OnBordingRepo.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

protocol OnBordingRepo{
    func getAllTracks() async throws -> [Track]
}
