//
//  JobDTO+Mapper.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import Foundation

private let placeholderURL = URL(string: "about:blank")!

extension JobDTO {
    func toDomain() -> JobEntity {
        JobEntity(
            id: id ?? 0,
            title: title ?? "Untitled Role",
            companyName: companyName ?? "Unknown Company",
            location: location ?? "—",
            description: description ?? "",
            employmentType: employmentType ?? "—",
            seniorityLevel: seniorityLevel ?? "—",
            requiredSkills: requiredSkills ?? [],
            preferredSkills: preferredSkills ?? [],
            technologies: technologies ?? [],
            applicationUrl: applicationUrl.flatMap(URL.init(string:)) ?? placeholderURL,
            sourceUrl: sourceUrl.flatMap(URL.init(string:)) ?? placeholderURL,
            sourceType: sourceType ?? "URL",
            createdAt: createdAt ?? "",
            companyLogoUrl: companyLogoUrl.flatMap(URL.init(string:)) ?? placeholderURL,
            postedLabel: postedLabel ?? "",
            applicantsLabel: applicantsLabel ?? ""
        )
    }
}
