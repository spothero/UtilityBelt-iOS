// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
import SwiftUI

/// A helper class to assist with all CoreData operations.
public class CoreDataManager {
    // MARK: Default Instance
    
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
    
    // MARK: Properties
    
    /// The persistent container to use for all requests. Must be set prior to performing any operations.
    private var persistentContainer: NSPersistentContainer?
    
    // MARK: Methods
    
    /// Initializes a new CoreDataManger with no persistent container.
    /// This is only used for the static default instance of this class.
    /// All operations on the default instance will fail until the default container is set.
    private init() { }
    
    /// Initializes a new CoreDataManager.
    /// - Parameter container: The persistent container to use for all operations.
    public required init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    /// Fetches all managed objects of a given type.
    /// - Parameter type: The type of entity to fetch all results for.
    public func fetch<T: NSManagedObject>(type: T.Type) throws -> [T] {
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)

        return try self.managedContext().fetch(fetchRequest)
    }
    
    /// Fetches all managed objects with a given entity name.
    /// - Parameter entityName: The name of the entity to fetch all results for.
    public func fetch(entityName: String) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

        return try self.managedContext().fetch(fetchRequest)
    }
    
    /// Creates a new instance of a managed object subclass.
    /// - Parameter type: The managed object subclass type to create.
    /// - Parameter context: The managed object context to create the object in. If nil, uses the current default context.
    public func newInstance<T: NSManagedObject>(of type: T.Type, in context: NSManagedObjectContext? = nil) throws -> T? {
        let context = try (context ?? self.managedContext())

        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as? T
    }
    
    /// Saves the current managed object context.
    public func save() throws {
        try self.managedContext().save()
    }
    
    /// Returns the persistent container's view context for convenient reference.
    private func managedContext() throws -> NSManagedObjectContext {
        guard let persistentContainer = self.persistentContainer else {
            throw UBDataError.defaultPersistentContainerNotSet
        }
        
        return persistentContainer.viewContext
    }
}
