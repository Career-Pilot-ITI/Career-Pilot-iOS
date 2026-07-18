//
//  UserEntity.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {}

extension UserEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var phoneNumber: String
    @NSManaged public var isNewUser: Bool
    @NSManaged public var profile: UserProfileEntity?
}
