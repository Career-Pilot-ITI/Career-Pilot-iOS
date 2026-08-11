//
//  Job.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import Foundation

struct JobEntity: Identifiable, Equatable {
    let id: Int
    let title: String
    let companyName: String
    let location: String
    let description: String
    let employmentType: String
    let seniorityLevel: String
    let requiredSkills: [String]
    let preferredSkills: [String]
    let technologies: [String]
    let applicationUrl: URL
    let sourceUrl: URL
    let sourceType: String
    let createdAt: Date
    let companyLogoUrl: URL
    let postedLabel: String
    let applicantsLabel: String
}
