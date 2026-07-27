//
//  Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation

extension UserProfileEntity {
    func toUserSettingsDomain() -> UserSettingsDomain {
        let skillsSet: Set<SkillEntity> = (skills as? Set<SkillEntity>) ?? []
               let skillList: [Skill] = skillsSet.map { $0.toDomain() }
        
        return UserSettingsDomain(
            displayName: displayName ?? "",
            username: username ?? "",
            phoneNumber: "01554132837",
            email: email ?? "",
            avatar: nil,
            targetRole: targetRole,
            industry: industry,
            experienceLevel: experienceLevel ?? "",
            currentJobTitle: currentJobTitle ?? "",  cvUrl: URL(string: "") ?? nil,
            skills: skillList,
            subscriptionTier: subscriptionTier,
            coinBalance: Int(coinBalance),
            trackName: "",
            trackId: 0
        )
    }
}
