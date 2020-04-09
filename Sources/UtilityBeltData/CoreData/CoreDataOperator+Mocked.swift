// Copyright © 2020 SpotHero, Inc. All rights reserved.

#if canImport(XCTest)

    import CoreData

    public extension CoreDataOperator {
        /// Creates a mocked `CoreDataOperator` for use with testing.
        /// - Parameter name: The name of the Data Model to persist.
        /// - Parameter storeType: The method of storage for this `CoreDataOperator`. Defaults to In Memory.
        static func mocked(name: String, storeType: NSPersistentContainer.StoreType = .memory) -> CoreDataOperator {
            return CoreDataOperator(persistentContainer: .mocked(name: name, storeType: storeType))
        }
    }

#endif