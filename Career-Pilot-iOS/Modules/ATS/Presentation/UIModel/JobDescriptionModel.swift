//
//  JobDescriptionModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

struct JobDescriptionModel {
    let companyInitial: String
    let title: String
    let company: String
    let location: String
    let workMode: String

    let employmentType: String
    let experienceLevel: String
    let postedText: String
    let appliedText: String

    let description: String

    let skills: [String]
    let skillsCount: Int
    let preferredSkills: [String]
    let preferredSkillsCount: Int
    let technologies: [String]
    let technologiesCount: Int

    static let mock = JobDescriptionModel(
        companyInitial: "G",
        title: "Senior Frontend Engineer",
        company: "Google",
        location: "Cairo, EG",
        workMode: "Hybrid",
        employmentType: "Full-time",
        experienceLevel: "Senior (5+ yrs)",
        postedText: "2 days ago",
        appliedText: "1000+ Person",
        description: "We are looking for a Senior Frontend Engineer to join our Cairo office. You will lead the development of user-facing features for Google's cloud products, collaborating with designers and backend engineers to deliver performant, accessible web applications at scale.",
        skills: ["TypeScript", "Node.js", "System Design", "AWS", "REST APIs"],
        skillsCount: 8,
        preferredSkills: ["GraphQL"],
        preferredSkillsCount: 3,
        technologies: ["Kubernetes", "Go", "GraphQL"],
        technologiesCount: 3
    )
}

