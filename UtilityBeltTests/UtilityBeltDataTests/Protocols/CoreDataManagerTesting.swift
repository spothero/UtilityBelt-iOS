// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
@testable import UtilityBeltData
import XCTest

protocol CoreDataManagerTesting: XCTestCase {
    var storeType: NSPersistentContainer.StoreType { get }
}

extension CoreDataManagerTesting {
    func initialize() {
        CoreDataManager.defaultContainer = .mocked(name: "UtilityBeltData", storeType: self.storeType)

        do {
            try self.loadData()
        } catch {
            XCTFail(error.localizedDescription)
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

            XCTAssertFalse(userExists)
        }
    }
    
    func exists(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let userExists = try CoreDataManager.default.exists(User.self)

            XCTAssertTrue(userExists)
        }
    }
    
    func fetchAll(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let users = try CoreDataManager.default.fetchAll(of: User.self)

            XCTAssertNotNil(users)
            XCTAssertEqual(users.count, 4)
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
