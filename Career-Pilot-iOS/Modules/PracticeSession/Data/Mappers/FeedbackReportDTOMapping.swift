//
//  FeedbackReportDTOMapping.swift
//  Career-Pilot-iOS
//

import Foundation

extension FeedbackReportDTO {

    func toDomain() -> InterviewFeedback {
        InterviewFeedback(
            overallScore: Double(overallScore),
            communicationScore: Double(clarityScore),
            technicalScore: Double(contentRelevanceScore),
            strengths: [],       // not present on FeedbackReportDTO yet
            weaknesses: [],      // not present on FeedbackReportDTO yet
            recommendations: coachingTips
        )
    }
}
