//
//  UserDataRepo.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

protocol UserDataRepo{
    func uploadUserCV(uploadCVRequest: UploadCvRequest) async throws -> UploadCvResponse
}
