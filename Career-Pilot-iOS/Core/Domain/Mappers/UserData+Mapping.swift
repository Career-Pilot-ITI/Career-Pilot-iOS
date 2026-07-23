////
////    UserData+Mapping.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 20/07/2026.
////
//
//import Foundation
//
//extension UserData {
//    func toUserProfile() -> UserProfile {
//        UserProfile(
//            displayName: self.fullName,
//            username: self.email.components(separatedBy: "@").first ?? "",
//            email: self.email,
//            avatarUrl: nil,
//            avatarFileId: self.avatarFileId,
//            cvFileId: nil, gender: self.gender,
//            dateOfBirth: nil,
//            targetRole: self.selectedTrack?.title,
//            industry: nil,
//            experienceLevel: self.experienceLevel,
//            currentJobTitle: self.title,
//            yearsOfExperience: nil,
//            cvUrl: self.cv,
//            skills: self.skills.isEmpty ? nil : self.skills,
//            targetCompanies: nil,
//            educationLevel: nil,
//            timezone: nil,
//            termsAccepted: true,
//            subscriptionTier: nil,
//            coinBalance: nil,
//            onboardingCompleted: true,
//            trackName: self.selectedTrack?.title,
//            trackId: 1
//        )
//    }
//}
