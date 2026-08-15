//
//  JobMatchModels.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 09/08/2026.
//

import Foundation

enum Priority: String {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

struct RequirementKeyword: Identifiable {
    let id = UUID()
    let name: String
    let priority: Priority
}

struct SuggestedEdit: Identifiable {
    enum Icon: String {
        case skills = "pencil"
        case keyword = "target"
        case impact = "chart.line.uptrend.xyaxis"
    }

    let id = UUID()
    let icon: Icon
    let title: String
    let impact: Priority
    let description: String
}

struct JobMatch {
    let companyInitial: String
    let jobTitle: String
    let companyName: String
    let location: String
    let workMode: String
    let score: Int
    let matchedKeywords: [String]
    let missingKeywords: [RequirementKeyword]
    let totalKeywordCount: Int
    let suggestedEdits: [SuggestedEdit]

    var matchLabel: String {
        switch score {
        case 80...100: return "Great Match"
        case 60..<80: return "Good Match"
        default: return "Weak Match"
        }
    }

    var priorityMissingCount: Int {
        missingKeywords.filter { $0.priority != .low }.count
    }
}

extension JobMatch {
    /// Sample data matching the provided design — swap for real backend data.
    static let mock = JobMatch(
        companyInitial: "G",
        jobTitle: "Senior Frontend Engineer",
        companyName: "Google",
        location: "Cairo, EG",
        workMode: "Hybrid",
        score: 73,
        matchedKeywords: ["React", "TypeScript", "Node.js", "System Design", "AWS", "REST APIs", "Leadership", "Agile"],
        missingKeywords: [
            RequirementKeyword(name: "Kubernetes", priority: .high),
            RequirementKeyword(name: "Go", priority: .high),
            RequirementKeyword(name: "GraphQL", priority: .medium),
            RequirementKeyword(name: "Terraform", priority: .medium),
            RequirementKeyword(name: "Agile/Scrum", priority: .low)
        ],
        totalKeywordCount: 12,
        suggestedEdits: [
            SuggestedEdit(
                icon: .skills,
                title: "Add Kubernetes to Skills",
                impact: .high,
                description: "The role requires container orchestration. Add Kubernetes to your Skills section and briefly mention any hands-on experience."
            ),
            SuggestedEdit(
                icon: .keyword,
                title: "Mention GraphQL experience",
                impact: .medium,
                description: "You have REST API depth — bridge it to GraphQL. Even a side-project mention raises your keyword match significantly."
            ),
            SuggestedEdit(
                icon: .impact,
                title: "Quantify your AWS impact",
                impact: .medium,
                description: "Replace 'used AWS' with specific services and metrics — e.g. 'Reduced latency 40% using Lambda + CloudFront'."
            )
        ]
    )
}
