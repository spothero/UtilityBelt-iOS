// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation
@testable import UtilityBeltData
import XCTest

protocol CoreDataOperatorTesting: XCTestCase {
    var coreDataOperator: CoreDataOperator { get set }
    
    func testNewInstance()
    
    func testExists()
    func testExistsWithPredicate()
    
    func testCount()
    func testCountWithPredicate()
    
    func testFetch()
    func testFetchWithPredicate()
    
    func testFetchMultiple()
    func testFetchMultipleWithPredicate()
    func testFetchMultipleWithSortDescriptors()
    func testFetchMultipleWithFetchLimit()
    
    func testDeleteSingleObject()
    func testDeleteAllObjects()
    func testDeleteAllObjectsWithPredicate()
    func testDeleteAllObjectsUsingBatchDelete() throws
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
    
    func verifyExistsSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Verify no users exist when we start
            XCTAssertFalse(try self.coreDataOperator.exists(User.self),
                           file: file,
                           line: line)
            
            // Create a user object
            try self.createUser(firstName: "Test",
                                lastName: "User",
                                email: "test@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify a user object now exists
            XCTAssertTrue(try self.coreDataOperator.exists(User.self),
                          file: file,
                          line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyExistsWithPredicateSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Verify no users exist when we start
            XCTAssertFalse(try self.coreDataOperator.exists(User.self),
                           file: file,
                           line: line)
            
            // Create a user objects
            try self.createUser(firstName: "First",
                                lastName: "User",
                                email: "first@spothero.com")
            try self.createUser(firstName: "Second",
                                lastName: "User",
                                email: "second@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify passing predicate for matching object returns true
            let matchingPredicate = NSPredicate(key: #keyPath(User.email), contains: "spothero")
            XCTAssertTrue(try self.coreDataOperator.exists(User.self, with: matchingPredicate),
                          file: file,
                          line: line)
            
            // Verify passing predicate for no matching objects returns false
            let nonMatchingPredicate = NSPredicate(key: #keyPath(User.email), contains: "gmail")
            XCTAssertFalse(try self.coreDataOperator.exists(User.self, with: nonMatchingPredicate),
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
                           0,
                           file: file,
                           line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    // MARK: Fetch
    
    func verifyFetchSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Create a user in Core Data
            try self.createUser(firstName: "Test",
                                lastName: "User",
                                email: "test@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify fetch returns the user
            let user = try XCTUnwrap(self.coreDataOperator.fetch(User.self))
            XCTAssertEqual(user.email,
                           "test@spothero.com",
                           file: file,
                           line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyFetchWithPredicateSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Create users in Core Data
            try self.createUser(firstName: "First",
                                lastName: "User",
                                email: "first@spothero.com")
            try self.createUser(firstName: "Second",
                                lastName: "User",
                                email: "second@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify a fetch with a predicate returns the correct user
            let secondUserPredicate = NSPredicate(key: #keyPath(User.email),
                                                  equalTo: "second@spothero.com")
            let user = try XCTUnwrap(self.coreDataOperator.fetch(User.self,
                                                                 with: secondUserPredicate),
                                     file: file,
                                     line: line)
            XCTAssertEqual(user.email, "second@spothero.com")
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyFetchMultipleSucceeds(file: StaticString = #file, line: UInt = #line) {
        do {
            // Create users in Core Data
            try self.createUser(firstName: "First",
                                lastName: "User",
                                email: "first@spothero.com")
            try self.createUser(firstName: "Second",
                                lastName: "User",
                                email: "second@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify the fetch returns all users
            let users = try self.coreDataOperator.fetchMultiple(of: User.self)
            XCTAssertEqual(users.count, 2, file: file, line: line)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyFetchMultipleWithPredicateSucceeds(file: StaticString = #file,
                                                  line: UInt = #line) {
        do {
            // Create users in Core Data
            try self.createUser(firstName: "A",
                                lastName: "User",
                                email: "a@spothero.com")
            try self.createUser(firstName: "B",
                                lastName: "User",
                                email: "b@spothero.com")
            try self.createUser(firstName: "C",
                                lastName: "User",
                                email: "c@gmail.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify fetching with a predicate succeeds
            let gmailPredicate = NSPredicate(key: #keyPath(User.email), contains: "gmail")
            let gmailUsers = try self.coreDataOperator.fetchMultiple(of: User.self, with: gmailPredicate)
            XCTAssertEqual(gmailUsers.count, 1)
            XCTAssertEqual(gmailUsers.first?.email, "c@gmail.com")
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyFetchMultipleWithSortDescriptorsSucceeds(file: StaticString = #file,
                                                        line: UInt = #line) {
        do {
            // Create users in Core Data
            try self.createUser(firstName: "A",
                                lastName: "User",
                                email: "a@spothero.com")
            try self.createUser(firstName: "C",
                                lastName: "User",
                                email: "c@spothero.com")
            try self.createUser(firstName: "B",
                                lastName: "User",
                                email: "b@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify fetching with a sort descriptor succeeds
            let firstNameSort = NSSortDescriptor(key: #keyPath(User.firstName), ascending: true)
            let sortedUsers = try self.coreDataOperator.fetchMultiple(of: User.self, sortDescriptors: [firstNameSort])
            XCTAssertEqual(sortedUsers.count, 3)
            XCTAssertEqual(sortedUsers[0].firstName, "A")
            XCTAssertEqual(sortedUsers[1].firstName, "B")
            XCTAssertEqual(sortedUsers[2].firstName, "C")
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func verifyFetchMultipleWithFetchLimitSucceeds(file: StaticString = #file,
                                                   line: UInt = #line) {
        do {
            // Create users in Core Data
            try self.createUser(firstName: "A",
                                lastName: "User",
                                email: "a@spothero.com")
            try self.createUser(firstName: "B",
                                lastName: "User",
                                email: "b@spothero.com")
            try self.createUser(firstName: "C",
                                lastName: "User",
                                email: "c@spothero.com")
            try self.coreDataOperator.saveDefaultContext()
            
            // Verify a fetch without a limit returns 3 users
            let noLimitUsers = try self.coreDataOperator.fetchMultiple(of: User.self)
            XCTAssertEqual(noLimitUsers.count, 3)
            
            // Verify fetching with a limit succeeds
            let limitedUsers = try self.coreDataOperator.fetchMultiple(of: User.self, fetchLimit: 2)
            XCTAssertEqual(limitedUsers.count, 2)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    // MARK: Delete
    
    func verifyDeleteSingleObjectsSucceeds(file: StaticString = #file, line: UInt = #line) {
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
    
    func verifyDeleteAllObjectsSucceeds(file: StaticString = #file, line: UInt = #line) {
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
    
    func verifyDeleteAllObjectsWithPredicateSucceeds(file: StaticString = #file, line: UInt = #line) {
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
    
    func verifyDeleteAllObjectsUsingBatchDeleteSucceeds(file: StaticString = #file, line: UInt = #line) {
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
            
            // Delete all user objects using a batch delete.
            try self.coreDataOperator.deleteAll(of: User.self, batchDelete: true)
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
