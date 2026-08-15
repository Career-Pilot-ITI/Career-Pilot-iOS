//
//  AiJobDTO+Mapper.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation

extension AiJobDataDTO {
    func toEntity() -> AiJobEntity {
        AiJobEntity(
            id: id,
            workspaceId: workspaceId,
            type: AiJobType(rawDTO: type),
            status: AiJobStatus(rawDTO: status),
            progressPercentage: progressPercentage ?? 0,
            currentStep: currentStep ?? "",
            errorMessage: errorMessage,
            createdAt: createdAt ?? "",
            startedAt: startedAt,
            completedAt: completedAt,
            result: result?.toEntity()
        )
    }
}

extension CvOptimizationResultDTO {
    func toEntity() -> CvOptimizationResult {
        CvOptimizationResult(
            sections: (sections ?? []).map { $0.toEntity() },
            recommendedTracks: recommendedTracks ?? [],
            coinCost: coinCost ?? 0
        )
    }
}

extension CvSectionDTO {
    func toEntity() -> CvSection {
        CvSection(
            name: name ?? "",
            score: score ?? 0,
            improvements: (improvements ?? []).map { $0.toEntity() }
        )
    }
}

extension CvSectionImprovementDTO {
    func toEntity() -> CvSectionImprovement {
        CvSectionImprovement(
            original: original ?? "",
            improved: improved ?? "",
            reason: reason ?? ""
        )
    }
}
