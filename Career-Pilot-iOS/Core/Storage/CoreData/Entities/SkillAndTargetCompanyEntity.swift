//
//  SkillAndTargetCompanyEntity.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation
import CoreData

@objc(SkillEntity)
public class SkillEntity: NSManagedObject {}

extension SkillEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SkillEntity> {
        NSFetchRequest<SkillEntity>(entityName: "SkillEntity")
    }

    @NSManaged public var value: String
    @NSManaged public var profile: UserProfileEntity?
}

@objc(TargetCompanyEntity)
public class TargetCompanyEntity: NSManagedObject {}

extension TargetCompanyEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TargetCompanyEntity> {
        NSFetchRequest<TargetCompanyEntity>(entityName: "TargetCompanyEntity")
    }

    @NSManaged public var value: String
    @NSManaged public var profile: UserProfileEntity?
}

