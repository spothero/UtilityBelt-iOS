// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
import XCTest

final class CoreDataOperatorSQLiteTests: XCTestCase, CoreDataOperatorTesting {
    var coreDataOperator: CoreDataOperator = .mocked(name: "UtilityBeltData", storeType: .sqlite, managedObjectModel: .mocked)
    
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
