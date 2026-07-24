import CoreData

protocol UserLocalDataSourceProtocol {
    func save(_ user: User) async throws
    func loadUser() async throws -> User?
    func clear() async throws
}

final class CoreDataUserLocalDataSource: UserLocalDataSourceProtocol {
    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }

    func save(_ user: User) async throws {
        try await coreDataManager.performBackgroundTask { [coreDataManager] context in
            let existing = try coreDataManager.fetch(UserEntity.fetchRequest(), in: context)
            coreDataManager.delete(existing, in: context)

            let entity = UserEntity(context: context)
            entity.id = Int64(user.id)
            entity.phoneNumber = user.phoneNumber
            entity.isNewUser = user.isNewUser

            let profileEntity = UserProfileEntity(context: context)
            profileEntity.displayName = user.profile.displayName
            profileEntity.username = user.profile.username
            profileEntity.email = user.profile.email
            profileEntity.avatarUrl = user.profile.avatarURL
            profileEntity.gender = user.profile.gender
            profileEntity.dateOfBirth = user.profile.dateOfBirth.toDate()
            profileEntity.targetRole = user.profile.targetRole
            profileEntity.industry = user.profile.industry
            profileEntity.experienceLevel = user.profile.experienceLevel
            profileEntity.currentJobTitle = user.profile.currentJobTitle
            profileEntity.yearsOfExperience = Int32(user.profile.yearsOfExperience )
            profileEntity.cvUrl = user.profile.cvURL
            profileEntity.educationLevel = user.profile.educationLevel
            profileEntity.timezone = user.profile.timezone
            profileEntity.termsAccepted = user.profile.termsAccepted
            profileEntity.subscriptionTier = user.profile.subscriptionTier
            profileEntity.coinBalance = Int32(user.profile.coinBalance )
            profileEntity.onboardingCompleted = user.profile.onboardingCompleted
            profileEntity.trackName = user.profile.trackName
            profileEntity.user = entity

            for _ in user.profile.skills {
                let skillEntity = SkillEntity(context: context)
//                skillEntity.value = skill
                skillEntity.profile = profileEntity
            }
            for company in user.profile.targetCompanies {
                let companyEntity = TargetCompanyEntity(context: context)
                companyEntity.value = company
                companyEntity.profile = profileEntity
            }
        }
    }

    func loadUser() async throws -> User? {
        try await coreDataManager.performViewContextTask { [coreDataManager] context -> User? in
            let request = UserEntity.fetchRequest()
            request.fetchLimit = 1
            guard let entity = try coreDataManager.fetch(request, in: context).first else { return nil }
            return try entity.toDomain()
        }
    }

    func clear() async throws {
        try await coreDataManager.performBackgroundTask { [coreDataManager] context in
            let existing = try coreDataManager.fetch(UserEntity.fetchRequest(), in: context)
            coreDataManager.delete(existing, in: context)
        }
    }
}
