//
//  JobMatchEntity+UIMapper.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 13/08/2026.
//

import SwiftUI

extension JobMatchEntity {
    /// Maps the domain entity to the UI model consumed by JobMatchView.
    /// Requires the parent JobEntity to populate the job header card.
    func toUIModel(job: JobEntity) -> JobMatchData {
        let jobPosting = JobPosting(
            title: job.title,
            company: "\(job.companyName) · \(job.location)",
            location: job.location,
            workType: job.employmentType,
            logoInitial: job.companyName.first.map(String.init) ?? "?",
            logoColor: Color.accentOrange
        )

        let sectionScores: [SectionScore] = sections.enumerated().map { index, s in
            let isLowest = s.score == sections.min(by: { $0.score < $1.score })?.score
            return SectionScore(
                name: s.section,
                score: s.score,
                detail: s.feedback.isEmpty ? nil : s.feedback,
                isLowest: isLowest
            )
        }

        let recommendations: [Recommendation] = self.recommendations.enumerated().map { index, text in
            Recommendation(index: index + 1, text: text)
        }

        return JobMatchData(
            job: jobPosting,
            matchScore: overallScore,
            matchLabel: matchLabel,
            matchedCount: matchedSkills.count,
            missingCount: missingRequiredSkills.count + missingPreferredSkills.count,
            totalKeywords: totalKeywordsCount,
            matchedRequirements: matchedSkills,
            missingRequired: missingRequiredSkills,
            missingPreferred: missingPreferredSkills,
            strengths: strengths,
            weaknesses: weaknesses,
            sectionScores: sectionScores,
            recommendations: recommendations
        )
    }
}
