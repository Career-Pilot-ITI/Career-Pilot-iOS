//
//  JobPosting.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//


import SwiftUI

struct JobPosting: Identifiable {
    let id = UUID()
    let title: String
    let company: String
    let location: String
    let workType: String
    let logoInitial: String
    let logoColor: Color
}

struct SectionScore: Identifiable {
    let id = UUID()
    let name: String
    let score: Int
    let detail: String?
    let isLowest: Bool

    var color: Color {
        switch score {
        case 0..<60: return .matchRed
        case 60..<80: return .matchOrange
        default: return .matchGreen
        }
    }
}

struct Recommendation: Identifiable {
    let id = UUID()
    let index: Int
    let text: String
}

enum SkillStatus {
    case matched
    case missingRequired
    case missingPreferred
}

struct JobMatchData {
    let job: JobPosting
    let matchScore: Int
    let matchLabel: String
    let matchedCount: Int
    let missingCount: Int
    let totalKeywords: Int

    let matchedRequirements: [String]
    let missingRequired: [String]
    let missingPreferred: [String]

    let strengths: [String]
    let weaknesses: [String]

    let sectionScores: [SectionScore]
    let recommendations: [Recommendation]
}

extension JobMatchData {
    /// Sample data mirroring the provided design mockups.
    static let sample = JobMatchData(
        job: JobPosting(
            title: "Senior Frontend Engineer",
            company: "Google · Cairo, EG · Hybrid",
            location: "Cairo, EG",
            workType: "Hybrid",
            logoInitial: "G",
            logoColor: .init(red: 0.93, green: 0.35, blue: 0.24)
        ),
        matchScore: 78,
        matchLabel: "Good Match",
        matchedCount: 8,
        missingCount: 5,
        totalKeywords: 12,
        matchedRequirements: [
            "React", "TypeScript", "Node.js", "System Design", "AWS", "REST APIs", "Leadership", "Agile"
        ],
        missingRequired: [
            "Agile", "Agile", "Agile", "Agile", "Agile", "Agile"
        ],
        missingPreferred: [
            "Terraform"
        ],
        strengths: [
            "Strong frontend architecture with measurable impact",
            "Leadership at scale demonstrated across multiple roles",
            "Excellent system design breadth — well aligned to the JD"
        ],
        weaknesses: [
            "No Kubernetes or container orchestration mentioned",
            "DevOps / CI-CD toolchain exposure is thin"
        ],
        sectionScores: [
            SectionScore(name: "Projects", score: 59, detail: nil, isLowest: true),
            SectionScore(name: "Summary", score: 65, detail: nil, isLowest: false),
            SectionScore(name: "Skills", score: 76, detail: nil, isLowest: false),
            SectionScore(name: "Work Experience", score: 88, detail: nil, isLowest: false),
            SectionScore(name: "Education", score: 92, detail: "Relevant degree and institution. Section is clean and well-formatted.", isLowest: false)
        ],
        recommendations: [
            Recommendation(index: 1, text: "Add Kubernetes to your Skills with a brief hands-on description"),
            Recommendation(index: 2, text: "Quantify AWS impact — e.g. 'Reduced latency 40% via Lambda + CloudFront'"),
            Recommendation(index: 3, text: "Expand project entries with business metrics and user impact"),
            Recommendation(index: 4, text: "Rewrite Summary to lead with large-scale React architecture experience"),
            Recommendation(index: 5, text: "Add a Certifications section if you hold AWS or cloud certs")
        ]
    )
}
