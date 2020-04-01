// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation

/// A helper class to assist with all CoreData operations.
public class CoreDataOperator {
    // MARK: - Shared Instance

    /// The shared instance of `CoreDataManager`.
    ///
    /// Users must call one of the static `initializeSharedContext` methods on this class before
    /// operations will work without requiring a passed-in context.
    public private(set) static var shared = CoreDataOperator()

    // MARK: - Properties

    /// The default managed object context for all requests.
    private var defaultContext: NSManagedObjectContext?

    // MARK: - Methods

    // MARK: Initializers

    private init() {
        self.defaultContext = nil
    }

    /// Initializes a new `CoreDataOperator` with a given managed object context.
    /// - Parameter context: The managed object context to use for all operations.
    public required init(context: NSManagedObjectContext) {
        self.defaultContext = context
    }

    /// Initializes a new `CoreDataOperator` using the view context from a given `NSPersistentContainer`.
    /// - Parameter persistentContainer: The persistent container that owns the view context to use for all operations.
    public convenience init(persistentContainer: NSPersistentContainer) {
        self.init(context: persistentContainer.viewContext)
    }

    /// Initializes the shared `CoreDataOperator` instance's default managed object context.
    /// - Parameter context: The managed object context to use for all operations.
    public static func initializeSharedContext(_ context: NSManagedObjectContext) {
        Self.shared.defaultContext = context
    }

    /// Initializes the shared `CoreDataOperator` instance's default managed object context
    /// using the view context from a given `NSPersistentContainer`.
    /// - Parameter persistentContainer: The persistent container that owns the view context to use for all operations.
    public static func initializeSharedContext(from persistentContainer: NSPersistentContainer) {
        Self.shared.defaultContext = persistentContainer.viewContext
    }

    // MARK: Count

    /// Returns the count of a given managed object.
    /// - Parameter type: The type of managed object to count.
    /// - Parameter predicate: The predicate to filter the request by.
    /// - Parameter context: The managed object context to perform the count operation in. If nil, uses the current default context.
    public func count<T: NSManagedObject>(of type: T.Type,
                                          with predicate: NSPredicate? = nil,
                                          in context: NSManagedObjectContext? = nil) throws -> Int {
        guard let context = context ?? self.defaultContext else {
            throw UBCoreDataError.managedObjectContextNotFound
        }

        // Instead of using T.fetchRequest(), we build the FetchRequest so we don't need to cast the result
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.includesPropertyValues = false
        fetchRequest.includesSubentities = false
        fetchRequest.predicate = predicate

        let count = try context.count(for: fetchRequest)

        // If the fetched objects were not found, ensure that we return 0
        return (count != NSNotFound) ? count : 0
    }

    // MARK: Create

    /// Creates a new instance of a managed object subclass.
    /// - Parameter type: The managed object subclass type to create.
    /// - Parameter context: The managed object context to create the object in. If nil, uses the current default context.
    public func newInstance<T: NSManagedObject>(of type: T.Type, in context: NSManagedObjectContext? = nil) throws -> T? {
        guard let context = context ?? self.defaultContext else {
            throw UBCoreDataError.managedObjectContextNotFound
        }

        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as? T
    }

    // MARK: Delete

    /// Deletes a single managed object.
    /// - Parameter object: The object to delete.
    public func delete<T: NSManagedObject>(_ object: T) throws {
        guard let context = object.managedObjectContext else {
            throw UBCoreDataError.objectHasNoManagedObjectContext(object)
        }

        context.delete(object)
        try context.save()
    }

    /// Deletes all objects of a given entity type.
    /// - Parameter type: The entity type to batch delete.
    /// - Parameter predicate: The predicate to filter the request by.
    /// - Parameter context: The managed object context to perform the delete operation in. If nil, uses the current default context.
    ///
    /// Batch delete requests are only compatible with the SQLite store type.
    ///
    /// **Sources**
    /// - [Implementing Batch Deletes](https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html)
    public func deleteAll<T: NSManagedObject>(of type: T.Type,
                                              with predicate: NSPredicate? = nil,
                                              in context: NSManagedObjectContext? = nil) throws {
        guard let context = context ?? self.defaultContext else {
            throw UBCoreDataError.managedObjectContextNotFound
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try context.executeAndMergeChanges(using: deleteRequest)

        try context.save()
    }

    // MARK: Exists

    /// Checks whether a given type of entity exists.
    /// - Parameter type: The type of entity to check existence for.
    /// - Parameter predicate: The predicate to filter the request by.
    /// - Parameter context: The managed object context to use when checking for existence of a given object type.
    ///                      If nil, uses the current default context.
    public func exists<T: NSManagedObject>(_ type: T.Type,
                                           with predicate: NSPredicate? = nil,
                                           in context: NSManagedObjectContext? = nil) throws -> Bool {
        return try self.count(of: type, with: predicate, in: context) > 0
    }

    // MARK: Fetch

    /// Fetches all managed objects of a given type.
    /// - Parameter type: The type of entity to fetch all results for.
    /// - Parameter predicate: The predicate to filter the request by.
    /// - Parameter context: The managed object context to perform the fetch operation in. If nil, uses the current default context.
    public func fetchAll<T: NSManagedObject>(of type: T.Type,
                                             with predicate: NSPredicate? = nil,
                                             in context: NSManagedObjectContext? = nil) throws -> [T] {
        guard let context = context ?? self.defaultContext else {
            throw UBCoreDataError.managedObjectContextNotFound
        }

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
        try self.save(context: self.defaultContext)
    }

    /// Saves a managed object context if there are changes.
    /// - Parameter context: The managed object context to save.
    private func save(context: NSManagedObjectContext?) throws {
        guard let context = context else {
            throw UBCoreDataError.managedObjectContextNotFound
        }

        if context.hasChanges == true {
            try context.save()
        }
    }
}
