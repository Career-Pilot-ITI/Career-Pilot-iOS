//
//  Mapping.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation

extension UserEntity {
    
    func toUserSettingsDomain() -> UserSettingsDomain {
        let profile = self.profile
        let domainSkills: [Skill] = (profile?.skills as? NSSet)?
            .compactMap { $0 as? SkillEntity }
            .map { skillEntity in
                Skill(
                    skillName: skillEntity.skillName ?? "",
                    category: skillEntity.category ?? "",
                    performanceScore: Int(skillEntity.performanceScore),
                    timesAssessed: Int(skillEntity.timesAssessed),
                    lastAssessedAt: skillEntity.lastAssessedAt ?? ""
                )
            } ?? []
        
        
        let avatarData: Data? = nil
        
        return UserSettingsDomain(
            displayName: profile?.displayName ?? "",
            username: profile?.username ?? "",
            phoneNumber: self.phoneNumber ?? "",
            email: profile?.email ?? "",
            avatar: avatarData,
            avatarURL: profile?.avatarURL.flatMap { URL(string: $0) }, targetRole: profile?.targetRole,
            industry: profile?.industry,
            experienceLevel: profile?.experienceLevel ?? "",
            currentJobTitle: profile?.currentJobTitle ?? "",
            cvUrl: profile?.cvURL.map { URL(string: $0) } ?? nil,   skills: domainSkills,
            subscriptionTier: profile?.subscriptionTier,
            coinBalance: Int(profile?.coinBalance ?? 0),
            trackName: "",
            
            trackId: Int(profile?.trackId ?? 0)
        )
    }
}
