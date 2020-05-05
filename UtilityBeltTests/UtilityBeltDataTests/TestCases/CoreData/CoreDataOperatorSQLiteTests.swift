// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataOperatorSQLiteTests: XCTestCase, CoreDataOperatorTesting {
    var coreDataOperator: CoreDataOperator = .mocked(name: "UtilityBeltData", storeType: .sqlite)
    
    override func setUp() {
        super.setUp()
        
        self.loadData()
    }
    
    func testCount() {
        self.count()
    }
    
    func testDelete() {
        self.delete()
    }
    
    func testExists() {
        self.exists()
    }
    
    func testFetch() {
        self.fetchAll()
    }
}
