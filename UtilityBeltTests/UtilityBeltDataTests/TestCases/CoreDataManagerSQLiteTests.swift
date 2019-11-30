// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
@testable import UtilityBeltData
@testable import UtilityBeltDemo
import XCTest

class CoreDataManagerSQLiteTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        do {
            CoreDataManager.defaultContainer = .mocked(name: "UtilityBeltData", storeType: .sqlite)

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
            XCTFail(error.localizedDescription)
        }
    }

    func testCount() {
        do {
            let userCount = try CoreDataManager.default.count(of: User.self)

            XCTAssertEqual(userCount, 4)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDelete() {
        do {
            try CoreDataManager.default.deleteAll(of: User.self)
            let userExists = try CoreDataManager.default.exists(User.self)
            
            XCTAssertFalse(userExists)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testExists() {
        do {
            let userExists = try CoreDataManager.default.exists(User.self)

            XCTAssertTrue(userExists)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetch() {
        do {
            let users = try CoreDataManager.default.fetchAll(of: User.self)

            XCTAssertNotNil(users)
            XCTAssertEqual(users.count, 4)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    private func loadData(file: StaticString = #file, line: UInt = #line) throws {
        let alice = try User.newInstance()
        alice?.firstName = "Alice"
        alice?.lastName = "Anderson"
        alice?.email = "alice@spothero.com"

        let bob = try User.newInstance()
        bob?.firstName = "Bob"
        bob?.lastName = "Barker"
        bob?.email = "bob@spothero.com"

        let carol = try User.newInstance()
        carol?.firstName = "Carol"
        carol?.lastName = "Chompers"
        carol?.email = "carol@spothero.com"

        let dave = try User.newInstance()
        dave?.firstName = "Dave"
        dave?.lastName = "Davison"
        dave?.email = "dave@spothero.com"

        try CoreDataManager.default.saveDefaultContext()
    }
}
