////
////  UpdateProfileDTO+Mapping.swift
////  Career-Pilot-iOS
////
////  Created by Ahmed El-Sayyad Mohamed on 21/07/2026.
////
//
//import Foundation
////UserProfileDTO
//
//extension UpdateProfileDTO {
//
//    func toDomain(id: Int = 0, phoneNumber: String = "", isNewUser: Bool = false) -> User {
//        let profile = UserProfile(
//            displayName: self.displayName ?? "",
//            username: self.username ?? "",
//            email: self.email ?? "",
//            avatarUrl: self.av,
//            avatarFileId: self.avatarFileId,
//            cvFileId: self.cvFileId,
//            gender: self.gender,
//            dateOfBirth: self.dateOfBirth?.toDate(),
//            targetRole: self.targetRole,
//            industry: self.industry,
//            experienceLevel: self.experienceLevel,
//            currentJobTitle: self.currentJobTitle,
//            yearsOfExperience: self.yearsOfExperience,
//            cvUrl: nil,
//            skills: (self.skills ?? []).map { $0.toDomain() },
//            targetCompanies: self.targetCompanies,
//            educationLevel: self.educationLevel,
//            timezone: self.timezone,
//            termsAccepted: self.termsAccepted ?? false,
//            subscriptionTier: self.subscriptionTier,
//            coinBalance: nil,
//            onboardingCompleted: self.onboardingCompleted,
//            trackName: nil,
//            trackId: self.trackId
//        )
//        
//        return User(
//            id: id,
//            phoneNumber: phoneNumber,
//            profile: profile,
//            isNewUser: isNewUser
//        )
//    }
//}
