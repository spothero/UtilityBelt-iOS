// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData

public extension NSPersistentContainer {
    /// The persistent container store type.
    enum StoreType {
        /// Stores data in binary.
        case binary
        /// Stores data in-memory.
        case memory
        /// Stores data in a SQLite database.
        case sqlite

        #if os(OSX)
            /// Stores data in an XML file. Extremely slow and only available on macOS 10.4+.
            case xml
        #endif

        var rawValue: String {
            switch self {
            case .binary:
                return NSBinaryStoreType
            case .memory:
                return NSInMemoryStoreType
            case .sqlite:
                return NSSQLiteStoreType
            #if os(OSX)
                case .xml:
                    return NSXMLStoreType
            #endif
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
