//
//  ChoseTrackViewInfo.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import Foundation

struct SelectedTrackViewInfo{
    var filteredTracks: [Track] = tracks
    var selectedTrack: Track?
}

let tracks = [
    Track(
        id: 1,
        title: "Software Engineering",
        description: "Design, build, and maintain software applications.",
        isActive: true
    ),
    Track(
        id: 2,
        title: "Data Science",
        description: "Analyze data to extract insights and support decision-making.",
        isActive: true
    ),
    Track(
        id: 3,
        title: "Product Management",
        description: "Lead product strategy, planning, and execution.",
        isActive: true
    ),
    Track(
        id: 4,
        title: "UX Design",
        description: "Create intuitive and user-friendly digital experiences.",
        isActive: true
    ),
    Track(
        id: 5,
        title: "Marketing",
        description: "Promote products and grow brand awareness.",
        isActive: true
    ),
    Track(
        id: 6,
        title: "Finance & Banking",
        description: "Manage financial operations and investment strategies.",
        isActive: true
    ),
    Track(
        id: 7,
        title: "Consulting",
        description: "Provide expert advice to solve business challenges.",
        isActive: true
    ),
    Track(
        id: 8,
        title: "Business Analysis",
        description: "Identify business needs and recommend solutions.",
        isActive: true
    ),
    Track(
        id: 9,
        title: "DevOps & SRE",
        description: "Automate infrastructure and improve system reliability.",
        isActive: true
    ),
    Track(
        id: 10,
        title: "Machine Learning",
        description: "Build intelligent models that learn from data.",
        isActive: true
    ),
    Track(
        id: 11,
        title: "Cybersecurity",
        description: "Protect systems and data from security threats.",
        isActive: true
    ),
    Track(
        id: 12,
        title: "Sales",
        description: "Drive revenue through customer acquisition and relationships.",
        isActive: true
    ),
    Track(
        id: 13,
        title: "HR & Talent",
        description: "Recruit, develop, and retain top talent.",
        isActive: true
    ),
    Track(
        id: 14,
        title: "Customer Success",
        description: "Help customers achieve value from products and services.",
        isActive: true
    )
]
