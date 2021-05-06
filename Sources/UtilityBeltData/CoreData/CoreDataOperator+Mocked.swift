// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if !os(watchOS) && canImport(XCTest)
    
    import CoreData
    
    @available(iOS 10.0, watchOS 3.0, *)
    public extension CoreDataOperator {
        /// Creates a mocked `CoreDataOperator` for use with testing.
        /// - Parameter name: The name of the Data Model to persist.
        /// - Parameter storeType: The method of storage for this `CoreDataOperator`. Defaults to In Memory.
        /// - Parameter managedObjectModel: By default, the provided name value of the container is used as the name of
        ///                                 the persisent store associated with the container. Passing in the `NSManagedObjectModel`
        ///                                 object overrides the lookup of the model by the provided name value.
        static func mocked(name: String,
                           storeType: NSPersistentContainer.StoreType = .memory,
                           managedObjectModel: NSManagedObjectModel? = nil) -> CoreDataOperator {
            return CoreDataOperator(persistentContainer: .mocked(name: name, storeType: storeType, managedObjectModel: managedObjectModel))
        }
    }
    
#endif
