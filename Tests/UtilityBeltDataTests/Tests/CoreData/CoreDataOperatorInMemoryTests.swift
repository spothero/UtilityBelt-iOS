// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
import XCTest

final class CoreDataOperatorInMemoryTests: XCTestCase, CoreDataOperatorTesting {
    // MARK: Properties
    
    var coreDataOperator: CoreDataOperator = .mocked(name: "UtilityBeltData", storeType: .memory, managedObjectModel: .mocked)
    
    // MARK: Create Tests
    
    func testNewInstance() {
        self.verifyNewInstanceSucceeds()
    }
    
    // MARK: Exists Tests
    
    func testExists() {
        self.verifyExistsSucceeds()
    }
    
    func testExistsWithPredicate() {
        self.verifyExistsWithPredicateSucceeds()
    }
    
    // MARK: Count Tests
    
    func testCount() {
        self.verifyCountSucceeds()
    }
    
    func testCountWithPredicate() {
        self.verifyCountWithPredicateSucceeds()
    }
    
    // MARK: Delete Tests
    
    func testDeleteSingleObject() {
        self.verifyDeleteSingleObjectsSucceeds()
    }
    
    func testDeleteAllObjects() {
        self.verifyDeleteAllObjectsSucceeds()
    }
    
    func testDeleteAllObjectsWithPredicate() {
        self.verifyDeleteAllObjectsWithPredicateSucceeds()
    }
}
