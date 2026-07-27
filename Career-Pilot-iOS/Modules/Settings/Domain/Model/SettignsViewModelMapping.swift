//
//  SettignsViewModelMapping.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation
import UIKit

extension UserSettingsDomain {
    func toUserModelSettingsView() async -> UserModelSettingsView {
        return UserModelSettingsView(
            email: email,
            title: currentJobTitle,
            fullName: displayName,
            avatar: avatar == nil ? nil : UIImage(data: avatar!),
            experienceLevel: experienceLevel,
            skills: skills,
            coinBalance: "\(coinBalance)",
            subscriptionPlan: subscriptionTier ?? "Free",
            phoneNumber: "",
            cvUrl: cvUrl ?? nil
        )
    }
}

//extension UserModelSettingsView {
//    func toUserSettingsDomain() -> UserSettingsDomain {
//        UserSettingsDomain(
//            displayName: fullName,
//            username: fullName,
//            phoneNumber: "01554132837",
//            email: email,
//            avatar: ,
//            targetRole: experienceLevel,
//            industry: "",
//            experienceLevel: experienceLevel,
//            currentJobTitle: title,
//            cvUrl: cvUrl ,
//            skills: skills,
//            subscriptionTier: subscriptionPlan,
//            coinBalance: Int(coinBalance) ?? 0,
//            trackName: title,
//            trackId: 0
//        )
//    }
//}
