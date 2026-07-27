//
//  OnBordingRemoteDataSource.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


protocol OnBordingRemoteDataSource{
    func getAllTraks() async throws -> [TrackDTO]
    func updateUserProfile(updateProfileRequestDTO: UpdateProfileRequestDTO) async throws -> UpdateProfileResponseDTO
}

class OnBordingRemoteDataSourceImp: OnBordingRemoteDataSource{
    
    var apiService: NetworkService
    
    init(apiService: NetworkService) {
        self.apiService = apiService
    }
    
    func getAllTraks() async throws -> [TrackDTO] {
        let endPoint = OnBordingEndPointes.getAllTrackes
        
        return try await apiService.request(endPoint)
    }
    
    func updateUserProfile(updateProfileRequestDTO: UpdateProfileRequestDTO) async throws -> UpdateProfileResponseDTO {
            let endPoint = OnBordingEndPointes.updateUserProfile(updateProfileRequestDTO: updateProfileRequestDTO)
            
            print("🌐 [RemoteDataSource] Sending update profile request to: \(endPoint.baseURL)/\(endPoint.path)")
            
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let data = try? encoder.encode(updateProfileRequestDTO),
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 [RemoteDataSource] Request Payload:\n\(jsonString)")
                }
                
                let updateProfileResponseDTO: UpdateProfileResponseDTO = try await apiService.request(endPoint)
                print("✅ [RemoteDataSource] Profile updated successfully from server.")
                return updateProfileResponseDTO
                
            } catch {
                print("🔴 [RemoteDataSource] Update profile failed with error: \(error)")
                print("🔴 Error localized description: \(error.localizedDescription)")
                throw error
            }
        }
}
