//
//  UploadedFile.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 26/07/2026.
//

import Foundation

struct UploadedFile: Equatable {
    let id: Int
    let originalName: String
    let url: String
    let sizeBytes: Int
    let createdAt: String
}
