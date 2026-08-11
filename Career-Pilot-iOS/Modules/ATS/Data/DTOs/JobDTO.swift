//
//  JobDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import Foundation

struct JobDTO: Decodable {
    let id: Int?
    let title: String?
    let companyName: String?
    let location: String?
    let description: String?
    let employmentType: String?
    let seniorityLevel: String?
    let requiredSkills: [String]?
    let preferredSkills: [String]?
    let technologies: [String]?
    let applicationUrl: String?
    let sourceUrl: String?
    let sourceType: String?
    let createdAt: Date?
    let companyLogoUrl: String?
    let postedLabel: String?
    let applicantsLabel: String?
}
