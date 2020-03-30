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
}
