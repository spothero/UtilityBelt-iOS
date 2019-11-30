// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataManagerInMemoryTests: XCTestCase, UserDataLoading {
    override func setUp() {
        super.setUp()

        CoreDataManager.defaultContainer = .mocked(name: "UtilityBeltData", storeType: .memory)

        do {
            try self.loadData()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCount() {
        self.measureAndCatch {
            let userCount = try CoreDataManager.default.count(of: User.self)

            XCTAssertEqual(userCount, 4)
        }
    }

    func testExists() {
        self.measureAndCatch {
            let userExists = try CoreDataManager.default.exists(User.self)

            XCTAssertTrue(userExists)
        }
    }

    func testFetch() {
        self.measureAndCatch {
            let users = try CoreDataManager.default.fetchAll(of: User.self)

            XCTAssertNotNil(users)
            XCTAssertEqual(users.count, 4)
        }
    }
}
