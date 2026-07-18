//
//  CoreDataManager.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 17/07/2026.
//

import CoreData

protocol CoreDataManaging {
    var viewContext: NSManagedObjectContext { get }

    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T

    func performViewContextTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T

    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>, in context: NSManagedObjectContext) throws -> [T]
    func delete<T: NSManagedObject>(_ objects: [T], in context: NSManagedObjectContext)
    func save(_ context: NSManagedObjectContext) throws
}

final class CoreDataManager: CoreDataManaging {
    private let persistenceController: PersistenceController

    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }

    var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = persistenceController.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return try await context.perform {
            let result = try block(context)
            if context.hasChanges {
                try context.save()
            }
            return result
        }
    }

    func performViewContextTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = persistenceController.container.viewContext
        return try await context.perform {
            try block(context)
        }
    }

    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>, in context: NSManagedObjectContext) throws -> [T] {
        try context.fetch(request)
    }

    func delete<T: NSManagedObject>(_ objects: [T], in context: NSManagedObjectContext) {
        objects.forEach(context.delete)
    }

    func save(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
