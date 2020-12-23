// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
import XCTest

final class CoreDataOperatorSQLiteTests: XCTestCase, CoreDataOperatorTesting {
    // MARK: Properties
    
    var coreDataOperator: CoreDataOperator = .mocked(name: "UtilityBeltData", storeType: .sqlite, managedObjectModel: .mocked)
    
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
    
    // MARK: Fetch Tests
    
    func testFetch() {
        self.verifyFetchSucceeds()
    }
    
    func testFetchWithPredicate() {
        self.verifyFetchWithPredicateSucceeds()
    }
    
    func testFetchMultiple() {
        self.verifyFetchMultipleSucceeds()
    }
    
    func testFetchMultipleWithPredicate() {
        self.verifyFetchMultipleWithPredicateSucceeds()
    }
    
    func testFetchMultipleWithSortDescriptors() {
        self.verifyFetchMultipleWithSortDescriptorsSucceeds()
    }
    
    func testFetchMultipleWithFetchLimit() {
        self.verifyFetchMultipleWithFetchLimitSucceeds()
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
    
    func testDeleteAllObjectsUsingBatchDelete() throws {
        self.verifyDeleteAllObjectsUsingBatchDeleteSucceeds()
    }
}
