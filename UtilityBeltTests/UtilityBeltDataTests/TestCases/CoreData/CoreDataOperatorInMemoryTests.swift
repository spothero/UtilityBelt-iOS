// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataOperatorInMemoryTests: XCTestCase, CoreDataOperatorTesting {
    var coreDataOperator: CoreDataOperator = .mocked(name: "UtilityBeltData", storeType: .memory)

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
