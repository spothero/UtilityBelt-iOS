// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
@testable import UtilityBeltData
import XCTest

protocol CoreDataManagerTesting: XCTestCase {
    var storeType: NSPersistentContainer.StoreType { get }
}

extension CoreDataManagerTesting {
    func initialize(file: StaticString = #file, line: UInt = #line) {
        CoreDataManager.defaultContainer = .mocked(name: "UtilityBeltData", storeType: self.storeType)

        do {
            try self.loadData()
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }

    func count(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let userCount = try CoreDataManager.default.count(of: User.self)

            XCTAssertEqual(userCount, 4, file: file, line: line)
        }
    }

    func delete(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.storeType, .sqlite)

        self.measureAndCatch {
            try CoreDataManager.default.deleteAll(of: User.self)
            let userExists = try CoreDataManager.default.exists(User.self)

            XCTAssertFalse(userExists, file: file, line: line)
        }
    }

    func exists(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let userExists = try CoreDataManager.default.exists(User.self)

            XCTAssertTrue(userExists, file: file, line: line)
        }
    }

    func fetchAll(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let users = try CoreDataManager.default.fetchAll(of: User.self)

            XCTAssertNotNil(users, file: file, line: line)
            XCTAssertEqual(users.count, 4, file: file, line: line)
        }
    }

    private func loadData() throws {
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
