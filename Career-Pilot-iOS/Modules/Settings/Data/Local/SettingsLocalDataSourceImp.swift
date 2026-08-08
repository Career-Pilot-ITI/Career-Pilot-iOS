//
//  File.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation
import CoreData

class SettingsLocalDataSourceImp: SettingsLocalDataSource {
    private let coreDataManager: CoreDataManaging
    
    init(coreDataManager: CoreDataManaging = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchUserData() async throws -> UserEntity? {
        do {
            return try await coreDataManager.performViewContextTask { context in
                let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                request.fetchLimit = 1
                let results = try context.fetch(request)
                return results.first
            }
        } catch {
            print("Error Fetching User Data from database \(error)")
            throw error
        }
    }
    
    func updateUserData(user: UpdateProfileResponseDTO) async throws {
        do {
            try await coreDataManager.performBackgroundTask { context in
                // 1. Fetch or create the UserEntity inside the background context
                let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                request.fetchLimit = 1
                let userObjectInContext = try context.fetch(request).first ?? UserEntity(context: context)
                
                let backgroundProfileEntity = user.toEntity(context: context)
                userObjectInContext.phoneNumber = backgroundProfileEntity.phoneNumber
                
                if let profileObjectInContext = userObjectInContext.profile,
                   let newProfile = backgroundProfileEntity.profile {
                    profileObjectInContext.displayName = newProfile.displayName
                    profileObjectInContext.email = newProfile.email
                    profileObjectInContext.experienceLevel = newProfile.experienceLevel
                    profileObjectInContext.avatarURL = newProfile.avatarURL
                    // Safe because both profileObjectInContext and newProfile's skills are in 'context'
                    profileObjectInContext.skills = newProfile.skills
                    
                    profileObjectInContext.subscriptionTier = newProfile.subscriptionTier
                    profileObjectInContext.coinBalance = newProfile.coinBalance
                } else {
                    // If profile didn't exist yet, assign it directly
                    userObjectInContext.profile = backgroundProfileEntity.profile
                }
                
                try self.coreDataManager.save(context)
            }
        } catch {
            print("Error updating User Data in database \(error)")
            throw error
        }
    }
    func deleteUserData() async throws {
            do {
                try await coreDataManager.performBackgroundTask { context in
                    let request: NSFetchRequest<UserProfileEntity> = UserProfileEntity.fetchRequest()
                    request.fetchLimit = 1
                    
                    let results = try context.fetch(request)
                    guard let objectToDelete = results.first else {
                        throw CoreDataError.objectNotFound
                    }
                    
                    self.coreDataManager.delete([objectToDelete], in: context)
                    try self.coreDataManager.save(context)
                }
            } catch {
                print("Error deleting User Data from database \(error)")
                throw error
            }
        }
    func saveUserData(user: UserSettingsDTO)async throws -> UserEntity{
        do{
            let entity = user.toEntity(in: coreDataManager.viewContext )
            try self.coreDataManager.save(coreDataManager.viewContext)
            return entity
        }catch{
            print("The error we have  is \(error)")
            throw error
        }
    }
    }


enum CoreDataError: Error {
    case objectNotFound
}
