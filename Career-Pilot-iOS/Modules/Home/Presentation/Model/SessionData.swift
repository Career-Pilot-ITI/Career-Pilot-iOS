//
//  SessionData.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation

struct SessionData: Identifiable {
    let id = UUID()
    let score: Int
    let title: String
    let time: String
}

struct CareerItem: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let tagText: String
    let durationText: String
}
