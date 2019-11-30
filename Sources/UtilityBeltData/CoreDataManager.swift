// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
import SwiftUI

public enum UBDataStorageError: Error {
    case persistentContainerNotFound
    case entityNotFound(name: String)
}

public class CoreDataManager {
    public static let shared = CoreDataManager()

    private var persistentContainer: NSPersistentContainer?

    private init() {}

    public func setPersistentContainer(_ container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    public func fetch(entityName: String) throws -> [NSManagedObject] {
        guard let persistentContainer = persistentContainer else {
            throw UBDataStorageError.persistentContainerNotFound
        }

        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

        return try managedContext.fetch(fetchRequest)
    }

    func save(name: String) throws {
        guard let persistentContainer = persistentContainer else {
            throw UBDataStorageError.persistentContainerNotFound
        }

        let managedContext = persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
            throw UBDataStorageError.entityNotFound(name: "User")
        }

        let user = NSManagedObject(entity: entity, insertInto: managedContext)

        user.setValue(name, forKeyPath: "name")

        try managedContext.save()
    }
}

// class User: NSManagedObject, Identifiable {
//    var id: String = UUID().uuidString
//
//    var name: String
//
//    init(name: String) {
//
//        self.name = name
//
//        super.ini
//    }
// }
