//
//  Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation

extension UserProfileEntity {
    func toUserSettingsDomain() -> UserSettingsDomain {
        let avatar: URL? = avatarUrl.flatMap { URL(string: $0) }
        let cv: URL = cvUrl.flatMap { URL(string: $0) } ?? URL(string: "about:blank")!
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
            currentJobTitle: currentJobTitle ?? "",
            cvUrl: cv,
            skills: skillList,
            subscriptionTier: subscriptionTier,
            coinBalance: Int(coinBalance),
            trackName: trackName ?? "",
            trackId: 0
        )
    }
}
