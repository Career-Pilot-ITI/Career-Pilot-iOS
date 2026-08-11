//
//  JobMatchResultDTO.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//
import Foundation

struct JobMatchResultDTO: Decodable {
    let message: String?
    let success: Bool?
    let timestamp: Date?
    let data : JobDTO
}


