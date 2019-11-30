// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData

extension NSPersistentContainer {
    /// Creates a mocked persistent container that stores data in memory instead of on disk.
    /// - Parameter name: The name of the Data Model to persist.
    public static func mocked(name: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name) // , managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()

        // Storing in memory will prevent saving of data between runs
        description.type = NSInMemoryStoreType

        // Make operations synchronous for testing
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            // Check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType)

            // Check if creating container wrong
            if let error = error {
                fatalError("Failed to create persistent container. \(error.localizedDescription)")
            }
        }

        return container
    }
}
