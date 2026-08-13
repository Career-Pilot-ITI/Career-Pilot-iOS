//
//  JobEntity+UIMapper.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 13/08/2026.
//

import Foundation

extension JobEntity {
    /// Maps the domain entity to the UI model consumed by JobDescriptionView.
    func toDescriptionModel() -> JobDescriptionModel {
        // Derive a single-character company initial from the company name
        let initial = companyName.first.map(String.init) ?? "?"

        return JobDescriptionModel(
            companyInitial: initial,
            title: title,
            company: companyName,
            location: location,
            workMode: employmentType,
            employmentType: employmentType,
            experienceLevel: seniorityLevel,
            postedText: postedLabel,
            appliedText: applicantsLabel,
            description: description,
            skills: requiredSkills,
            skillsCount: requiredSkills.count,
            preferredSkills: preferredSkills,
            preferredSkillsCount: preferredSkills.count,
            technologies: technologies,
            technologiesCount: technologies.count
        )
    }
}
