// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataManagerSQLiteTests: XCTestCase, CoreDataManagerTesting {
    var storeType: NSPersistentContainer.StoreType = .sqlite

    override func setUp() {
        super.setUp()

        self.initialize()
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
