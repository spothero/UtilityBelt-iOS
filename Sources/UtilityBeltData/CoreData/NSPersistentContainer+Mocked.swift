// Copyright © 2020 SpotHero, Inc. All rights reserved.

#if !os(watchOS) && canImport(XCTest)

    import CoreData

    @available(iOS 10.0, watchOS 3.0, *)
    public extension NSPersistentContainer {
        /// Creates a mocked `NSPersistentContainer` for use with testing.
        /// - Parameter name: The name of the Data Model to persist.
        /// - Parameter storeType: The method of storage for this `NSPersistentContainer`. Defaults to In Memory.
        static func mocked(name: String, storeType: StoreType = .memory) -> NSPersistentContainer {
            let container = NSPersistentContainer(name: name)
            let description = NSPersistentStoreDescription()

            // Storing in memory will prevent saving of data between runs
            description.type = storeType.rawValue

            // Make operations synchronous for testing
            description.shouldAddStoreAsynchronously = false

            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { description, error in
                // Check if the data store matches
                precondition(description.type == storeType.rawValue)

                // Check if creating container wrong
                if let error = error {
                    fatalError("Failed to create persistent container. \(error.localizedDescription)")
                }
            }

            return container
        }
    }

#endif
