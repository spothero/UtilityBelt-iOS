// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
import OSLog
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataManagerSQLiteTests: XCTestCase, UserDataLoading {
    override func setUp() {
        super.setUp()

        CoreDataManager.defaultContainer = .mocked(name: "UtilityBeltData", storeType: .sqlite)

        do {
            try self.loadData()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    override func tearDown() {
        super.tearDown()

        do {
            try CoreDataManager.default.deleteAll(of: User.self)
        } catch {
            os_log("Failed to delete all records in tearDown step.")
        }
    }

    func testCount() {
        self.measureAndCatch {
            let userCount = try CoreDataManager.default.count(of: User.self)

            XCTAssertEqual(userCount, 4)
        }
    }

    func testDelete() {
        self.measureAndCatch {
            try CoreDataManager.default.deleteAll(of: User.self)
            let userExists = try CoreDataManager.default.exists(User.self)

            XCTAssertFalse(userExists)
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
