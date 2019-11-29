//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
//@testable import UtilityBeltNetworking
//
//import CoreData
//import XCTest
//
//final class GeneralTests: XCTestCase {
//    lazy var mockPersistantContainer: NSPersistentContainer = {
//        
//        let container = NSPersistentContainer(name: "PersistentTodoList", managedObjectModel: self.managedObjectModel)
//        let description = NSPersistentStoreDescription()
//        description.type = NSInMemoryStoreType
//        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
//        
//        container.persistentStoreDescriptions = [description]
//        container.loadPersistentStores { (description, error) in
//            // Check if the data store is in memory
//            precondition( description.type == NSInMemoryStoreType )
//                                        
//            // Check if creating container wrong
//            if let error = error {
//                fatalError("Create an in-mem coordinator failed \(error)")
//            }
//        }
//        return container
//    }()
//    
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
//        return managedObjectModel
//    }()
//    
//    func testGeneral() {
//    }
//}
