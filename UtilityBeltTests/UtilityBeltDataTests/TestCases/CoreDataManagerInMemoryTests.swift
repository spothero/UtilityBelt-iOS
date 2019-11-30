// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataManagerInMemoryTests: XCTestCase, CoreDataManagerTesting {
    var storeType: NSPersistentContainer.StoreType = .memory
    
    override func setUp() {
        super.setUp()

        self.initialize()
    }

    func testCount() {
        self.count()
    }

    func testExists() {
        self.exists()
    }

    func testFetch() {
        self.fetchAll()
    }
}
