// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
@testable import UtilityBeltData
import XCTest

protocol CoreDataOperatorTesting: XCTestCase {
    var coreDataOperator: CoreDataOperator { get set }
    
    func testNewInstance()
    
    func testCount()
    func testCountWithPredicate()
    
    func testDeleteSingleObject()
    func testDeleteAllObjects()
    func testDeleteAllObjectsWithPredicate()
}

extension CoreDataOperatorTesting {
    
    // MARK: Create
    
    func verifyNewInstanceSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Create a new user instance
            let user = try XCTUnwrap(self.coreDataOperator.newInstance(of: User.self),
                                     file: file,
                                     line: line)
            
            // Verify the entity name is correct
            XCTAssertEqual(user.entity.name,
                           "User",
                           file: file,
                           line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    // MARK: Count
    
    func verifyCountSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Verify we start with no data
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           0,
                           file: file,
                           line: line)
            
            // Create a user in Core Data
            try self.createUser(firstName: "Test",
                                lastName: "User",
                                email: "test@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify we have 1 object in Core Data
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           1,
                           file: file,
                           line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyCountWithPredicateSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Verify we start with no data
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           0,
                           file: file,
                           line: line)
            
            // Create users in Core Data
            try self.createUser(firstName: "First",
                                lastName: "User",
                                email: "first@spothero.com")
            try self.createUser(firstName: "Second",
                                lastName: "Second",
                                email: "second@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify we have 2 objects in Core Data
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self),
                           2,
                           file: file,
                           line: line)
            
            // Verify using a predicate with a match returns the correct number
            let secondUserPredicate = NSPredicate(key: #keyPath(User.email),
                                                  equalTo: "second@spothero.com")
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self, with: secondUserPredicate),
                           1,
                           file: file,
                           line: line)
            
            // Verify using a predicate without a match returns 0
            let unknownUserPredicate = NSPredicate(key: #keyPath(User.email),
                                                   equalTo: "notauser@spothero.com")
            XCTAssertEqual(try self.coreDataOperator.count(of: User.self, with: unknownUserPredicate),
                           1,
                           file: file,
                           line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
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
            try self.createUser(firstName: "First",
                                lastName: "User",
                                email: "first@spothero.com")
            try self.createUser(firstName: "Second",
                                lastName: "User",
                                email: "second@spothero.com")
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
            try self.createUser(firstName: "First",
                                lastName: "User",
                                email: "first@spothero.com")
            try self.createUser(firstName: "Second",
                                lastName: "User",
                                email: "second@gmail.com")
            try self.createUser(firstName: "Third",
                                lastName: "User",
                                email: "third@gmail.com")
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
    
    @discardableResult
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
