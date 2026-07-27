//
//  Persistence.swift
//  Career-Pilot-iOS
//
//  Created by Moaz Osama on 12/07/2026.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let user = UserEntity(context: viewContext)
        user.id = 1
        user.phoneNumber = "+201234567890"
        user.isNewUser = false

        let profile = UserProfileEntity(context: viewContext)
        profile.username = "preview_user"
        profile.displayName = "Preview User"
        profile.termsAccepted = true
        profile.coinBalance = 100
        profile.onboardingCompleted = true
        profile.user = user
        user.profile = profile

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Career_Pilot_iOS")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
