//
//  UploadFileResponseDTO.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 26/07/2026.
//

import Foundation

struct UploadFileResponseDTO: Decodable {
    let id: Int
    let type: String
    let originalName: String
    let url: String
    let sizeBytes: Int
    let createdAt: Date
}
