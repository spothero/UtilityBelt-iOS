// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation

public extension NSManagedObject {
    /// Creates a new instance of a managed object type.
    /// - Parameter context: The Managed Object Context to use.
    ///                      If nil, uses the currently set persistent container's context.
    static func newInstance(in context: NSManagedObjectContext? = nil) throws -> Self? {
        return try CoreDataManager.default.newInstance(of: Self.self, in: context)
    }
}
