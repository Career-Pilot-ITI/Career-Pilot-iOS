//
//  UplodeFile+Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 26/07/2026.
//

import Foundation

extension UploadFileResponseDTO{
    func toDomain() -> UploadedFile{
        return UploadedFile(id: id ?? 0, originalName: originalName ?? "", url: url ?? "", sizeBytes: sizeBytes ?? 0, createdAt: createdAt ?? "")
    }
}
