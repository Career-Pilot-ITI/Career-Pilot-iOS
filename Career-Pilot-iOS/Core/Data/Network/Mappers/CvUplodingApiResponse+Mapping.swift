//
//  UserDataMappers.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

extension CvUplodingResponseDTO{
    func toDomain() -> UploadCvResponse{
        let components = displayName?.components(separatedBy: " ")
        let firstName = components?.first ?? ""
        let lastName = components?.dropFirst().joined(separator: " ")
        
        let userData = OnBoardingUser(email: email ?? "", title: currentJobTitle ?? "Job Title", experienceLevel: experienceLevel ?? "No Level", skills: [Skill(skillName: "", category: "", performanceScore: 0, timesAssessed: 0, lastAssessedAt: "")], firstName: firstName, lastName: lastName ?? "")
        
        return UploadCvResponse(userData: userData)
    }
}
