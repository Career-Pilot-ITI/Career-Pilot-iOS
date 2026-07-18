//
//  UserDataMappers.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

extension CvUplodingResponseDTO{
    func toDomain() -> UploadCvResponse{
        let components = displayName.components(separatedBy: " ")
        let firstName = components.first ?? ""
        let lastName = components.dropFirst().joined(separator: " ")
        
        let userData = UserData(email: email, title: currentJobTitle ?? "Job Title", experienceLevel: experienceLevel ?? "No Level", skills: skills ?? [""], firstName: firstName, lastName: lastName)
        
        return UploadCvResponse(userData: userData)
    }
}
