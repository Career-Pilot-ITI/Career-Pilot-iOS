//
//  SettignsViewModelMapping.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation
import UIKit

extension UserSettingsDomain {
    
    func toUserModelSettingsView() -> UserModelSettingsView {
        print("The view of the avatar is \(UIImage(data: avatar!))")
        return UserModelSettingsView(
            email: email,
            title: currentJobTitle,
            fullName: displayName,
            avatar: avatar == nil ? nil : UIImage(data: avatar!),
            experienceLevel: experienceLevel,
            skills: skills,
            coinBalance: "\(coinBalance)",
            subscriptionPlan: subscriptionTier ?? "Free",
            phoneNumber: phoneNumber,
            cvUrl: cvUrl,
            username: username,
            avatarURL: avatarURL,
            targetRole: targetRole,
            industry: industry,
            trackName: trackName,
            trackId: trackId
        )
    }
    
    // MARK: - Domain to Update Profile Request DTO
    func toUpdateProfileRequestDTO() -> UpdateProfileRequestDTO {
        return UpdateProfileRequestDTO(
            username: username,
            email: email,
            displayName: displayName,
            avatarUrl: avatarURL?.absoluteString ?? "",
            avatarFileId: nil, // Map if you track file IDs in your domain
            gender: nil,       // Add field to domain if required by DTO
            dateOfBirth: nil,  // Add field to domain if required by DTO
            targetRole: targetRole ?? "",
            industry: industry,
            experienceLevel: experienceLevel,
            currentJobTitle: currentJobTitle,
            yearsOfExperience: nil, // Add to domain if needed
            cvUrl: cvUrl?.absoluteString,
            cvFileId: nil,
            // Map skill objects to string array of skill names:
            skills: skills.map { $0.skillName },
            targetCompanies: nil,
            educationLevel: nil,
            timezone: nil,
            termsAccepted: nil,
            onboardingCompleted: nil,
            trackId: trackId
        )
    }
    
    // MARK: - Domain to User Settings DTO
    func toDTO(originalDTO: UserSettingsDTO? = nil) -> UserSettingsDTO {
        return UserSettingsDTO(
            id: originalDTO?.id ?? 0,
            phoneNumber: phoneNumber,
            displayName: displayName,
            username: username,
            email: email,
            avatarUrl: avatarURL?.absoluteString ?? originalDTO?.avatarUrl,
            gender: originalDTO?.gender,
            dateOfBirth: originalDTO?.dateOfBirth,
            targetRole: targetRole,
            industry: industry,
            experienceLevel: experienceLevel,
            currentJobTitle: currentJobTitle,
            yearsOfExperience: originalDTO?.yearsOfExperience,
            cvUrl: cvUrl?.absoluteString,
            skills: skills.map { $0.toDTO() },
            targetCompanies: originalDTO?.targetCompanies,
            educationLevel: originalDTO?.educationLevel,
            timezone: originalDTO?.timezone,
            termsAccepted: originalDTO?.termsAccepted,
            subscriptionTier: subscriptionTier,
            coinBalance: coinBalance,
            onboardingCompleted: originalDTO?.onboardingCompleted,
            trackName: trackName,
            isnewUser: originalDTO?.isnewUser
        )
    }
}
extension UserModelSettingsView {
    
    // MARK: - View Model to Domain
    func toUserSettingsDomain() -> UserSettingsDomain {
        return UserSettingsDomain(
            displayName: fullName,
            username: username,
            phoneNumber: phoneNumber,
            email: email,
            avatar: avatar?.pngData(),
            avatarURL: avatarURL,
            targetRole: targetRole,
            industry: industry,
            experienceLevel: experienceLevel,
            currentJobTitle: title,
            cvUrl: cvUrl,
            skills: skills,
            subscriptionTier: subscriptionPlan,
            coinBalance: Int(coinBalance) ?? 0,
            trackName: trackName,
            trackId: trackId
        )
    }
}


