//
//  UserDataRepo.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

protocol UserDataRepo{
    
    func saveUser(_ user: User) async throws -> Bool
    func getUser() async throws -> User?
    func uploadUserCV(uploadCVRequest: UploadCvRequest) async throws -> UploadCvResponse
}
