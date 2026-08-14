//
//  SessionData.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 16/07/2026.
//

import Foundation
import SwiftUI

struct HomeSessionInfo: Identifiable {
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

struct PracticeTip: Identifiable {
    let id = UUID()
    let stepNumber: String
    let text: String
}

extension ReportsInterviewSession {
    static func toHomeSessionInfo(from session: ReportsInterviewSession) -> HomeSessionInfo {
        HomeSessionInfo(
            score: Int(session.overallScore ?? 0),
            title: session.trackName,
            time: "\(session.targetDurationMinutes) min"
        )
    }
}

extension InterviewTrack {
    
    static func makeTrack(from track: Track) -> InterviewTrack {
        let trackName = track.title.lowercased()
        
        switch trackName {
        case let name where name.contains("ios"):
            return InterviewTrack(
                track: track,
                iconName: "apple.logo",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Swift & SwiftUI",
                tagColor: .primary
            )
            
        case let name where name.contains("android"):
            return InterviewTrack(
                track: track,
                iconName: "phone.fill",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Kotlin & Compose",
                tagColor: .primary
            )
            
        case let name where name.contains("frontend"):
            return InterviewTrack(
                track: track,
                iconName: "desktopcomputer",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: React & Web",
                tagColor: .primary
            )
            
        case let name where name.contains("backend"):
            return InterviewTrack(
                track: track,
                iconName: "server.rack",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Node.js & Databases",
                tagColor: .primary
            )
            
        case let name where name.contains("full-stack") || name.contains("fullstack"):
            return InterviewTrack(
                track: track,
                iconName: "desktopcomputer",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Web & API",
                tagColor: .primary
            )
            
        case let name where name.contains("data analyst"):
            return InterviewTrack(
                track: track,
                iconName: "chart.bar.fill",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: SQL & Python",
                tagColor: .primary
            )
            
        case let name where name.contains("data engineer"):
            return InterviewTrack(
                track: track,
                iconName: "cylinder.split.1x2.fill",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Spark & Pipelines",
                tagColor: .primary
            )
            
        case let name where name.contains("machine learning") || name.contains("ai"):
            return InterviewTrack(
                track: track,
                iconName: "brain.head.profile",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: PyTorch & Models",
                tagColor: .primary
            )
            
        case let name where name.contains("qa") || name.contains("testing"):
            return InterviewTrack(
                track: track,
                iconName: "checkmark.seal.fill",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Automation & Testing",
                tagColor: .primary
            )
            
        case let name where name.contains("cybersecurity") || name.contains("security"):
            return InterviewTrack(
                track: track,
                iconName: "shield.checkered",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Security & Auth",
                tagColor: .primary
            )
            
        case let name where name.contains("devops") || name.contains("sre"):
            return InterviewTrack(
                track: track,
                iconName: "cloud.fill",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: Docker & K8s",
                tagColor: .primary
            )
            
        default:
            return InterviewTrack(
                track: track,
                iconName: "briefcase.fill",
                iconColor: .primary,
                iconBackground: Color.primary.opacity(0.12),
                tag: "Matches: General",
                tagColor: .primary
            )
        }
    }
}

extension InterviewLevel {
    static func inferLevel(from trackName: String) -> InterviewLevel {
        let name = trackName.lowercased()
        if name.contains("senior") {
            return .senior
        } else if name.contains("junior") {
            return .junior
        } else {
            return .mid
        }
    }
}
