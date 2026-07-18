//
//  UserProfileEntity.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import Foundation
import CoreData

@objc(UserProfileEntity)
public class UserProfileEntity: NSManagedObject {}

extension UserProfileEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
        NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var username: String
    @NSManaged public var email: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var gender: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var targetRole: String?
    @NSManaged public var industry: String?
    @NSManaged public var experienceLevel: String?
    @NSManaged public var currentJobTitle: String?
    @NSManaged public var yearsOfExperience: Int32
    @NSManaged public var cvUrl: String?
    @NSManaged public var educationLevel: String?
    @NSManaged public var timezone: String?
    @NSManaged public var termsAccepted: Bool
    @NSManaged public var subscriptionTier: String?
    @NSManaged public var coinBalance: Int32
    @NSManaged public var onboardingCompleted: Bool
    @NSManaged public var trackName: String?
    @NSManaged public var user: UserEntity?
    @NSManaged public var skills: NSSet?
    @NSManaged public var targetCompanies: NSSet?
}

extension UserProfileEntity {
    @objc(addSkillsObject:)
    @NSManaged public func addToSkills(_ value: SkillEntity)

    @objc(removeSkillsObject:)
    @NSManaged public func removeFromSkills(_ value: SkillEntity)

    @objc(addSkills:)
    @NSManaged public func addToSkills(_ values: NSSet)

    @objc(removeSkills:)
    @NSManaged public func removeFromSkills(_ values: NSSet)
}

extension UserProfileEntity {
    @objc(addTargetCompaniesObject:)
    @NSManaged public func addToTargetCompanies(_ value: TargetCompanyEntity)

    @objc(removeTargetCompaniesObject:)
    @NSManaged public func removeFromTargetCompanies(_ value: TargetCompanyEntity)

    @objc(addTargetCompanies:)
    @NSManaged public func addToTargetCompanies(_ values: NSSet)

    @objc(removeTargetCompanies:)
    @NSManaged public func removeFromTargetCompanies(_ values: NSSet)
}

