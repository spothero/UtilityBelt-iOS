// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
@testable import UtilityBeltData
import XCTest

protocol CoreDataOperatorTesting: XCTestCase {
    var coreDataOperator: CoreDataOperator { get set }
}

extension CoreDataOperatorTesting {
    func count(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let userCount = try self.coreDataOperator.count(of: User.self)
            
            XCTAssertEqual(userCount, 4, file: file, line: line)
        }
    }
    
    func delete(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            try self.coreDataOperator.deleteAll(of: User.self)
            let userExists = try self.coreDataOperator.exists(User.self)
            
            XCTAssertFalse(userExists, file: file, line: line)
        }
    }
    
    func exists(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let userExists = try self.coreDataOperator.exists(User.self)
            
            XCTAssertTrue(userExists, file: file, line: line)
        }
    }
    
    func fetchAll(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch {
            let users = try self.coreDataOperator.fetchMultiple(of: User.self)
            
            XCTAssertNotNil(users, file: file, line: line)
            XCTAssertEqual(users.count, 4, file: file, line: line)
        }
    }
    
    func loadData(file: StaticString = #file, line: UInt = #line) {
        do {
            let alice = try self.coreDataOperator.newInstance(of: User.self)
            alice?.firstName = "Alice"
            alice?.lastName = "Anderson"
            alice?.email = "alice@spothero.com"
            
            let bob = try self.coreDataOperator.newInstance(of: User.self)
            bob?.firstName = "Bob"
            bob?.lastName = "Barker"
            bob?.email = "bob@spothero.com"
            
            let carol = try self.coreDataOperator.newInstance(of: User.self)
            carol?.firstName = "Carol"
            carol?.lastName = "Chompers"
            carol?.email = "carol@spothero.com"
            
            let dave = try self.coreDataOperator.newInstance(of: User.self)
            dave?.firstName = "Dave"
            dave?.lastName = "Davison"
            dave?.email = "dave@spothero.com"
            
            try self.coreDataOperator.saveDefaultContext()
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
}
