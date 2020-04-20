// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation

@available(iOS 10.0, watchOS 3.0, *)
public extension NSManagedObject {
    /// Creates a new instance of a managed object using the shared instance of the `CoreDataOperator` class.
    /// - Parameter context: The Managed Object Context to use.
    ///                      If nil, uses the currently set persistent container's context.
    static func newInstance(in context: NSManagedObjectContext? = nil) throws -> Self? {
        return try CoreDataOperator.shared.newInstance(of: Self.self, in: context)
    }
}
