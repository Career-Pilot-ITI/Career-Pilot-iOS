//
//  CoverLetterDTO+Mapper.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 13/08/2026.
//

import Foundation

extension CoverLetterDTO {
    func toEntity() -> CoverLetterEntity {
        CoverLetterEntity(
            content: content ?? "",
            nextSteps: nextSteps ?? []
        )
    }
}
