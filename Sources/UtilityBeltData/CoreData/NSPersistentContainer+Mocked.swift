// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData

public extension NSPersistentContainer {
    /// The persistent container store type.
    ///
    /// Does **NOT** include the XML store type, which is only available on macOS 10.4+.
    enum StoreType {
        /// Stores data in binary.
        case binary
        /// Stores data in-memory.
        case memory
        /// Stores data in a SQLite database.
        case sqlite

        var rawValue: String {
            switch self {
            case .binary:
                return NSBinaryStoreType
            case .memory:
                return NSInMemoryStoreType
            case .sqlite:
                return NSSQLiteStoreType
            }
        }
    }

    /// Creates a mocked persistent container that stores data in memory instead of on disk.
    /// - Parameter name: The name of the Data Model to persist.
    static func mocked(name: String, storeType: StoreType = .memory) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name) // , managedObjectModel: self.managedObjectModel)
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
