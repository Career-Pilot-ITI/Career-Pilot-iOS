//
//  JobMatchResultDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import Foundation

struct JobDetailsResponseDTO: Decodable {
    let message: String?
    let success: Bool?
    let timestamp: String?
    let data : JobWorkSpaceDTO
}


struct JobWorkSpaceDTO: Decodable {
    let id: Int?
    let job: JobDTO
    let status: String?
    let createdAt: String?
}
