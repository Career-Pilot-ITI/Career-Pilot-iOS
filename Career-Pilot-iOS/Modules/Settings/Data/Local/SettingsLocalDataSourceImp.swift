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
    
    func fetchUserData() async throws -> UserProfileEntity? {
        do {
            return try await coreDataManager.performViewContextTask { context in
                let request: NSFetchRequest<UserProfileEntity> = UserProfileEntity.fetchRequest()
                request.fetchLimit = 1
                let results = try context.fetch(request)
                return results.first
            }
        } catch {
            print("Error Fetching User Data from database \(error)")
            throw error
        }
    }
    
    func updateUserData(userProfileEntity: UserProfileEntity) async throws {
        do {
            try await coreDataManager.performBackgroundTask { context in
                guard let objectInContext = try context.existingObject(with: userProfileEntity.objectID) as? UserProfileEntity else {
                    throw CoreDataError.objectNotFound
                }
                
                objectInContext.displayName = userProfileEntity.displayName
                objectInContext.email = userProfileEntity.email
                objectInContext.trackName = userProfileEntity.trackName
                objectInContext.experienceLevel = userProfileEntity.experienceLevel
                objectInContext.cvUrl = userProfileEntity.cvUrl
                objectInContext.skills = userProfileEntity.skills
                objectInContext.subscriptionTier = userProfileEntity.subscriptionTier
                objectInContext.coinBalance = userProfileEntity.coinBalance
                
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
    func saveUserData(user: UserDTO)async throws -> UserProfileEntity{
        do{
            let entity = user.profile.toEntity(context: coreDataManager.viewContext )
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
