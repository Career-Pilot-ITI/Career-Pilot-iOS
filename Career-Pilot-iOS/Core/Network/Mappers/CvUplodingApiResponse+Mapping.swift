//
//  UserDataMappers.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

extension CvUplodingApiResponse{
    func toDomain() -> UploadCvResponse{
        let components = self.profile.displayName.components(separatedBy: " ")
        let firstName = components.first ?? ""
        let lastName = components.dropFirst().joined(separator: " ")
        
        let userData = UserData(email: profile.email, title: profile.currentJobTitle ?? "Job Title", experienceLevel: profile.experienceLevel ?? "No Level", skills: profile.skills ?? [""], firstName: firstName, lastName: lastName)
        
        return UploadCvResponse(userData: userData)
    }
}
