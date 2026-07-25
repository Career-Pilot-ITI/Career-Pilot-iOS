//
//  UplodeFile+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 26/07/2026.
//

import Foundation

extension UploadFileResponseDTO{
    func toDomain() -> UploadedFile{
        return UploadedFile(id: id, originalName: originalName, url: url, sizeBytes: sizeBytes, createdAt: createdAt.ISO8601Format())
    }
}
