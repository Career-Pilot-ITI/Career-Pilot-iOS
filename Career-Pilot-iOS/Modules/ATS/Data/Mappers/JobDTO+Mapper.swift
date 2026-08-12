//
//  JobDTO+Mapper.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import Foundation

private let placeholderURL = URL(string: "about:blank")!

extension JobWorkSpaceDTO {
    func toEntity() -> JobEntity {
        JobEntity(
            workspaceID: id ?? 0,
            id: job.id ?? 0,
            title: job.title ?? "Untitled Role",
            companyName: job.companyName ?? "Unknown Company",
            location: job.location ?? "—",
            description: job.description ?? "",
            employmentType: job.employmentType ?? "—",
            seniorityLevel: job.seniorityLevel ?? "—",
            requiredSkills: job.requiredSkills ?? [],
            preferredSkills: job.preferredSkills ?? [],
            technologies: job.technologies ?? [],
            applicationUrl: job.applicationUrl.flatMap(URL.init(string:)) ?? placeholderURL,
            sourceUrl: job.sourceUrl.flatMap(URL.init(string:)) ?? placeholderURL,
            sourceType: job.sourceType ?? "URL",
            createdAt: job.createdAt ?? "",
            companyLogoUrl: job.companyLogoUrl.flatMap(URL.init(string:)) ?? placeholderURL,
            postedLabel: job.postedLabel ?? "",
            applicantsLabel: job.applicantsLabel ?? ""
        )
    }
}
