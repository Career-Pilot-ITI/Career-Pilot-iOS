//
//  TrackDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation

import Foundation

struct TrackDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let isActive: Bool
    let createdAt: Date
}
