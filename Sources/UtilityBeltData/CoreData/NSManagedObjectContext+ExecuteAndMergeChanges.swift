// Copyright © 2021 SpotHero, Inc. All rights reserved.

import CoreData

@available(iOS 10.0, watchOS 3.0, *)
internal extension NSManagedObjectContext {
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes
    /// to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    ///
    /// # Source
    /// [Using NSBatchDeleteRequest to delete batches in Core Data by Antoine Van Der Lee](https://www.avanderlee.com/swift/nsbatchdeleterequest-core-data/)
    func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        // We need the object IDs that get deleted so we can refresh our in-memory objects.
        // Additional Source: https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        // Execute the batch delete request and get the batch delete result
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        
        // Get the deleted object IDs out of the result
        let deletedObjectIDs = result?.result as? [NSManagedObjectID] ?? []
        
        // Put the delete result into the right format for merging changes
        let changeNotificationData: [AnyHashable: Any] = [NSDeletedObjectsKey: deletedObjectIDs]
        
        // Finally, merge the changes into this managed object context, effectively removing the deleted objects from memory
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changeNotificationData, into: [self])
    }
}
