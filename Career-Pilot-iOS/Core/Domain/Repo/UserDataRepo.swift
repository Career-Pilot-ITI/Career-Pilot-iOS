//
//  UserDataRepo.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

protocol UserDataRepo{
    
    func saveUser(_ user: User) async throws -> Bool
    func getCurrentUser() async throws -> User?
    func uploadUserCV(uploadCVRequest: UploadCvRequest) async throws -> UploadCvResponse
    func uploadUserFile(fileURL: URL, fileType: FileTypes) async throws -> UploadedFile
    
}
