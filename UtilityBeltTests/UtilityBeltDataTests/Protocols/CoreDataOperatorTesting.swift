// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
@testable import UtilityBeltData
import XCTest

protocol CoreDataOperatorTesting: XCTestCase {
    var coreDataOperator: CoreDataOperator { get set }
    
    func testDeleteSingleObject()
    func testDeleteAllObjects()
    func testDeleteAllObjectsWithPredicate()
}

extension CoreDataOperatorTesting {
    
    // MARK: Delete
    
    func verifyDeleteSingleObjectsSucceeds(file: StaticString = #file,
                                           line: UInt = #line) {
        do {
            // Create a user object in Core Data
            let user = try XCTUnwrap(self.createUser(firstName: "Test",
                                                     lastName: "User",
                                                     email: "test@spothero.com"),
                                     file: file,
                                     line: line)
            try self.coreDataOperator.saveDefaultContext()

            // Verify we now have 1 user object
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           1,
                           file: file,
                           line: line)
            
            // Delete the single user object
            try self.coreDataOperator.delete(user)
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify we now have 0 user objects
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           0,
                           file: file,
                           line: line)
            
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyDeleteAllObjectsSucceeds(file: StaticString = #file,
                                        line: UInt = #line) {
        do {
            // Create user objects in Core Data
            _ = try XCTUnwrap(self.createUser(firstName: "First",
                                              lastName: "User",
                                              email: "first@spothero.com"),
                              file: file,
                              line: line)
            _ = try XCTUnwrap(self.createUser(firstName: "Second",
                                              lastName: "User",
                                              email: "second@spothero.com"),
                              file: file,
                              line: line)
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify we now have 2 user objects
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           2,
                           file: file,
                           line: line)
            
            // Delete all user objects
            try self.coreDataOperator.deleteAll(of: User.self)
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify we now have 0 user objects
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           0,
                           file: file,
                           line: line)
            
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyDeleteAllObjectsWithPredicateSucceeds(file: StaticString = #file,
                                                     line: UInt = #line) {
        do {
            // Create user objects in Core Data
            _ = try XCTUnwrap(self.createUser(firstName: "First",
                                              lastName: "User",
                                              email: "first@spothero.com"),
                              file: file,
                              line: line)
            _ = try XCTUnwrap(self.createUser(firstName: "Second",
                                              lastName: "User",
                                              email: "second@gmail.com"),
                              file: file,
                              line: line)
            _ = try XCTUnwrap(self.createUser(firstName: "Third",
                                              lastName: "User",
                                              email: "third@gmail.com"),
                              file: file,
                              line: line)
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify we now have 3 user objects
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           3,
                           file: file,
                           line: line)
            
            // Delete all gmail user objects
            let gmailPredicate = NSPredicate(key: #keyPath(User.email), contains: "gmail")
            try self.coreDataOperator.deleteAll(of: User.self, with: gmailPredicate)
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify we now have 1 user object
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           1,
                           file: file,
                           line: line)
            let user = try XCTUnwrap(self.coreDataOperator.fetch(User.self),
                                     file: file,
                                     line: line)
            XCTAssertEqual(user.email,
                           "first@spothero.com",
                           file: file,
                           line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    // MARK: Utilities
    
    private func createUser(firstName: String,
                            lastName: String,
                            email: String) throws -> User? {
        let user = try self.coreDataOperator.newInstance(of: User.self)
        user?.firstName = firstName
        user?.lastName = lastName
        user?.email = email
        return user
    }
    
    private var userCount: Int {
        return (try? self.coreDataOperator.count(of: User.self)) ?? 0
    }
  
}
