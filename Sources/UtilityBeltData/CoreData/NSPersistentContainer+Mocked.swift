// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData

public extension NSPersistentContainer {
    /// Creates a mocked persistent container that stores data in memory instead of on disk.
    /// - Parameter name: The name of the Data Model to persist.
    static func mocked(name: String, storeType: StoreType = .memory) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name)
        let description = NSPersistentStoreDescription()

        // Storing in memory will prevent saving of data between runs
        description.type = storeType.rawValue

        // Make operations synchronous for testing
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            // Check if the data store is in memory
            precondition(description.type == storeType.rawValue)

            // Check if creating container wrong
            if let error = error {
                fatalError("Failed to create persistent container. \(error.localizedDescription)")
            }
        }

        return container
    }
}
