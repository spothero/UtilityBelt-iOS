// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataOperatorInMemoryTests: XCTestCase, CoreDataOperatorTesting {
    
    // MARK: Properties
    
    var coreDataOperator: CoreDataOperator = .mocked(name: "UtilityBeltData", storeType: .memory)

    // MARK: Create Tests
    
    func testNewInstance() {
        self.verifyNewInstanceSucceeds()
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
