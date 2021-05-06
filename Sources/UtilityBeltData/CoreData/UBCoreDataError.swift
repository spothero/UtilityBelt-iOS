// Copyright © 2021 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation

public enum UBCoreDataError: Error {
    case managedObjectContextNotFound
    case objectHasNoManagedObjectContext(NSManagedObject)
    case sharedCoreDataOperatorNotInitialized
}

extension UBCoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .managedObjectContextNotFound:
            return "No managed object context found."
        case let .objectHasNoManagedObjectContext(managedObject):
            return "The managed object context for the managed object '\(managedObject.entity)' is nil."
        case .sharedCoreDataOperatorNotInitialized:
            return "CoreDataOperator.shared is not initialized."
        }
    }
}
