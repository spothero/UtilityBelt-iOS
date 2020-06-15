// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataOperatorSQLiteTests: XCTestCase, CoreDataOperatorTesting {
    
    // MARK: Properties
    
    var coreDataOperator: CoreDataOperator = .mocked(name: "UtilityBeltData", storeType: .sqlite)
    
    // MARK: Tests
    
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
