//
//  AiJobEntity.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation

// MARK: - Enums

enum AiJobStatus: String {
    case pending    = "PENDING"
    case processing = "PROCESSING"
    case completed  = "COMPLETED"
    case failed     = "FAILED"
    
    /// Fallback for unknown status strings from the backend.
    case unknown
    
    init(rawDTO: String) {
        self = AiJobStatus(rawValue: rawDTO) ?? .unknown
    }
}

enum AiJobType: String {
    case cvOptimize = "CV_OPTIMIZE"
    case unknown
    
    init(rawDTO: String) {
        self = AiJobType(rawValue: rawDTO) ?? .unknown
    }
}

// MARK: - AI Job Entity

struct AiJobEntity {
    let id: Int
    let workspaceId: Int
    let type: AiJobType
    let status: AiJobStatus
    let progressPercentage: Int
    let currentStep: String
    let errorMessage: String?
    let createdAt: String
    let startedAt: String?
    let completedAt: String?
    let result: CvOptimizationResult?
}

// MARK: - CV Optimization Result

struct CvOptimizationResult {
    let sections: [CvSection]
    let recommendedTracks: [String]
    let coinCost: Int
}

// MARK: - CV Section

struct CvSection: Identifiable {
    let id = UUID()
    let name: String
    let score: Int
    let improvements: [CvSectionImprovement]
}

// MARK: - CV Section Improvement

struct CvSectionImprovement: Identifiable {
    let id = UUID()
    let original: String
    let improved: String
    let reason: String
}
