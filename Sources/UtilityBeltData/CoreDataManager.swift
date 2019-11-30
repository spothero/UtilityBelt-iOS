// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
import SwiftUI

/// A helper class to assist with all CoreData operations.
public class CoreDataManager {
    // MARK: - Default Instance

    /// The default instance of CoreDataManager.
    /// Until the default container is set, any operations on this instance will fail due to missing context.
    /// This is initialized with an empty persistent container
    public private(set) static var `default` = CoreDataManager()

    /// The default persistent container to use when referencing the default instance of CoreDataManager.
    public static var defaultContainer: NSPersistentContainer? {
        get {
            return self.default.persistentContainer
        }
        set {
            self.default.persistentContainer = newValue
        }
    }

    // MARK: - Properties

    /// The persistent container to use for all requests. Must be set prior to performing any operations.
    private var persistentContainer: NSPersistentContainer?

    // MARK: - Methods

    // MARK: Initializers

    /// Initializes a new CoreDataManger with no persistent container.
    /// This is only used for the static default instance of this class.
    /// All operations on the default instance will fail until the default container is set.
    private init() {}

    /// Initializes a new CoreDataManager.
    /// - Parameter container: The persistent container to use for all operations.
    public required init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    // MARK: Count

    /// Returns the count of a given managed object.
    /// - Parameter type: The type of managed object to count.
    public func count<T: NSManagedObject>(of type: T.Type,
                                          with predicate: NSPredicate? = nil) throws -> Int {
        // TODO: Figure out why T.fetchRequest() doesn't work here
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.includesPropertyValues = false
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate

        let count = try self.managedContext().count(for: fetchRequest)

        // If the fetched objects were not found, ensure that we return 0
        return (count != NSNotFound) ? count : 0
    }

    // MARK: Create

    /// Creates a new instance of a managed object subclass.
    /// - Parameter type: The managed object subclass type to create.
    /// - Parameter context: The managed object context to create the object in. If nil, uses the current default context.
    public func newInstance<T: NSManagedObject>(of type: T.Type, in context: NSManagedObjectContext? = nil) throws -> T? {
        let context = try (context ?? self.managedContext())

        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as? T
    }

    // MARK: Delete

    /// Deletes a single object.
    /// - Parameter object: The object to delete.
    public func delete<T: NSManagedObject>(_ object: T) throws {
        let context = try (object.managedObjectContext ?? self.managedContext())

        context.delete(object)
        try context.save()
    }

    /// Deletes all objects of a given entity type.
    /// - Parameter type: The entity type to batch delete.
    ///
    /// Batch delete requests are only compatible with the SQLite store type.
    public func deleteAll<T: NSManagedObject>(of type: T.Type,
                                              with predicate: NSPredicate? = nil) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try self.managedContext().executeAndMergeChanges(using: deleteRequest)

        try self.managedContext().save()
    }

    // MARK: Exists

    /// Checks whether a given type of entity exists.
    /// - Parameter type: The type of entity to check existence for.
    public func exists<T: NSManagedObject>(_ type: T.Type,
                                           with predicate: NSPredicate? = nil) throws -> Bool {
        return try self.count(of: type, with: predicate) > 0
    }

    // MARK: Fetch

    /// Fetches all managed objects of a given type.
    /// - Parameter type: The type of entity to fetch all results for.
    public func fetchAll<T: NSManagedObject>(of type: T.Type,
                                             with predicate: NSPredicate? = nil,
                                             in context: NSManagedObjectContext? = nil) throws -> [T] {
        let context = try (context ?? self.managedContext())

        // Instead of using T.fetchRequest(), we build the FetchRequest so we don't need to cast the result
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate

        return try context.fetch(fetchRequest)
    }

    // MARK: Save

    /// Saves the managed object context for a given object.
    /// - Parameter object: The object used to get a managed object context to save.
    public func save<T: NSManagedObject>(_ object: T) throws {
        try self.save(context: object.managedObjectContext)
    }

    /// Saves the default managed object context.
    public func saveDefaultContext() throws {
        try self.save(context: self.managedContext())
    }

    /// Saves a managed object context if there are changes.
    /// - Parameter context: The managed object context to save.
    private func save(context: NSManagedObjectContext?) throws {
        if context?.hasChanges == true {
            try context?.save()
        }
    }

    // MARK: Utilities

    /// Returns the persistent container's view context for convenient reference.
    private func managedContext() throws -> NSManagedObjectContext {
        guard let persistentContainer = self.persistentContainer else {
            throw UBDataError.defaultPersistentContainerNotSet
        }

        return persistentContainer.viewContext
    }
}
