//
//  SettingsRemoteImp.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
class SettingsRemoteImp : SettingsRemote{
    var apiService: NetworkService
    
    init(apiService: NetworkService) {
        self.apiService = apiService
    }
    
   
    
    func logoutUser()  async throws{
        let endpoint = SettingsEndpoint.logout
        do{
            
            return try await apiService.request(endpoint)
        }catch{
            print("Logout error : \(error)")
           throw error
        }
    }
    func getUserData() async throws -> UserSettingsDTO {
        let endpoint = SettingsEndpoint.getUserData
        do{
            return try await apiService.request(endpoint)
        }  catch {
            print("Actual error: \(error)")
            throw error
        }
    }
    func getSubscription()  async throws -> SubscribitonsPriceDTO{
        let endpoint = SettingsEndpoint.getSubscribtionsPrice

        var response = try await apiService.request(endpoint)
        print("user Data response = \(response)")
        return try await apiService.request(endpoint)
    }
    func getCoins() async {
        print("Here is the coin")
    }
    func updateUserProfile(updateProfileRequestDTO: UpdateProfileRequestDTO) async throws -> UpdateProfileResponseDTO {
        let endPoint = SettingsEndpoint.updateUserData(updateProfileRequestDTO)
            
            print("🌐 [RemoteDataSource] Sending update profile request to: \(endPoint.baseURL)/\(endPoint.path)")
            
            do {
                let updateProfileResponseDTO: UpdateProfileResponseDTO = try await apiService.request(endPoint)
                print("✅ [RemoteDataSource] Profile updated successfully from server.")
                return updateProfileResponseDTO
                
            } catch {
                print("🔴 [RemoteDataSource] Update profile failed with error: \(error)")
                print("🔴 Error localized description: \(error.localizedDescription)")
                throw error
            }
        }
    func updateUserProfileAvatar(avatarUploadRequestDTO : AvatarUploadDTO)async throws -> AvatarResponseDTO {
        let endpoint = SettingsEndpoint.updateUserAvatar(avatarUploadRequestDTO)
        return try await apiService.request(endpoint)
        
    }
}
