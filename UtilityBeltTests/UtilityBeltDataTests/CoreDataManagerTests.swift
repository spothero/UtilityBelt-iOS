// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltDataStorage
@testable import UtilityBeltDemo
import XCTest

class CoreDataManagerTests: XCTestCase {
    override func setUp() {
        CoreDataManager.shared.setPersistentContainer(.mocked(name: "UtilityBelt"))
    }

    func testFetch() {
        do {
            try CoreDataManager.shared.save(name: "Alice")
            try CoreDataManager.shared.save(name: "Bob")
            try CoreDataManager.shared.save(name: "Carol")
            try CoreDataManager.shared.save(name: "Dave")

            let users = try CoreDataManager.shared.fetch(entityName: "User")

            XCTAssertNotNil(users)
            XCTAssertEqual(users.count, 4)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
