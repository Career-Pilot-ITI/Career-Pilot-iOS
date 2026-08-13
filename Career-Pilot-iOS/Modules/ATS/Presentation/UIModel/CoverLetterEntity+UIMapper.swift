//
//  CoverLetterEntity+UIMapper.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 13/08/2026.
//

import Foundation

extension CoverLetterEntity {
    /// Maps the domain entity to the UI model consumed by CoverLetterView.
    func toUIModel(userContact: SignatureContact) -> CoverLetterData {
        // Split the raw content string on double newlines to get paragraphs.
        // Falls back to the full content as a single paragraph if no breaks exist.
        let paragraphs: [String] = content
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let recommendations: [Recommendation] = nextSteps.enumerated().map { index, text in
            Recommendation(index: index + 1, text: text)
        }

        return CoverLetterData(
            paragraphs: paragraphs.isEmpty ? [content] : paragraphs,
            signature: userContact,
            nextSteps: recommendations
        )
    }
}
