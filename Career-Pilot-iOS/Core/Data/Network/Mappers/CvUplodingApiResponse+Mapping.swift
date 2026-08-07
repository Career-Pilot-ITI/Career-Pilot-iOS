//
//  UserDataMappers.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

extension CvUplodingResponseDTO {
    func toDomain() -> UploadCvResponse {
        let components = displayName.components(separatedBy: " ")
        let firstName = components.first ?? ""
        let lastName = components.dropFirst().joined(separator: " ")
        
        let domainSkills: [Skill] = skills?.map { skillDTO in
            Skill(
                skillName: skillDTO.skillName ?? "",
                category: skillDTO.category ?? "",
                performanceScore: skillDTO.performanceScore ?? 0,
                timesAssessed: skillDTO.timesAssessed ?? 0,
                lastAssessedAt: skillDTO.lastAssessedAt ?? ""
            )
        } ?? []
        
        let userData = OnBoardingUser(
            email: email,
            title: currentJobTitle ?? "Job Title",
            experienceLevel: experienceLevel ?? "No Level",
            skills: domainSkills,
            firstName: firstName,
            lastName: lastName,
            cv : URL(string:cvUrl!)!
        )
        
        return UploadCvResponse(userData: userData)
    }
}
