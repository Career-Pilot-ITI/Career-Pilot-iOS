//
//  AiJobResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created on 15/08/2026.
//

import Foundation

// MARK: - Top-level response envelope

struct CvOptimizeResponseDTO: Decodable {
    let success: Bool?
    let message: String?
    let timestamp: String?
    let data: CvOptimizeDataDTO
}

// MARK: - AI Job data

struct CvOptimizeDataDTO: Decodable {
    let status: String?
    let progressPercentage: Int?
    let progress: Int?
    let currentStep: String?
    let errorMessage: String?
    let createdAt: String?
    let startedAt: String?
    let completedAt: String?
    let result: CvOptimizationResultDTO?
}

// MARK: - CV Optimization result (populated only on COMPLETED)

struct CvOptimizationResultDTO: Decodable {
    let sections: [CvSectionDTO]?
    let recommendedTracks: [String]?
    let coinCost: Int?
}

// MARK: - Section

struct CvSectionDTO: Decodable {
    let name: String?
    let score: Int?
    let improvements: [CvSectionImprovementDTO]?
}

// MARK: - Section Improvement

struct CvSectionImprovementDTO: Decodable {
    let original: String?
    let improved: String?
    let reason: String?
}
