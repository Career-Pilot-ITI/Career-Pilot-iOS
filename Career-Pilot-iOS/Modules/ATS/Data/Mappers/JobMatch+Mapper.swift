//
//  JobMatch+Mapper.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 12/08/2026.
//

import Foundation

extension JobMatchDTO {
    func toEntity() -> JobMatchEntity {
        JobMatchEntity(
            overallScore: overallScore ?? 0,
            matchPercentage: matchPercentage ?? 0,
            matchedSkills: matchedSkills ?? [],
            missingRequiredSkills: missingRequiredSkills ?? [],
            missingPreferredSkills: missingPreferredSkills ?? [],
            strengths: strengths ?? [],
            weaknesses: weaknesses ?? [],
            sections: (sections ?? []).map { $0.toEntity() },
            recommendations: recommendations ?? [],
            coinCost: coinCost ?? 0,
            cvScoreUpdatedAt: cvScoreUpdatedAt ?? ""
        )
    }
}

extension SectionScoreDTO {
    func toEntity() -> SectionScoreEntity {
        SectionScoreEntity(
            section: section ?? "",
            score: score ?? 0,
            feedback: feedback ?? ""
        )
    }
}
