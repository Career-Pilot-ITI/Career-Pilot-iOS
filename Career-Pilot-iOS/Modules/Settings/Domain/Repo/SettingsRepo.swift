//
//  ProfileProtocolRepo.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import Foundation
protocol  SettingsRepo{
    func fetchUserData() async throws -> UserSettingsDomain
    func logout() async throws
    func getSubscription() async throws -> [SubscriptionPlan]
    func getCoins() ->[CoinPack]
    func refreshUserData() async throws
    func getUserSubscription() async -> UserSubscribtionDomain
    func  updateUserProfile(updateProfileRequestDTO: UpdateProfileRequestDTO) async throws
    func updateUserProfileAvatar(avatarUploadRequestDTO : AvatarUploadDTO)async throws -> AvatarResponseDTO
    func saveUserData  ( user : UserSettingsDTO )async throws
    func downgradeUserSubscription() async throws
}
