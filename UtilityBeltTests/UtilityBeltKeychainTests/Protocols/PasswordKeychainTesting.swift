// Copyright © 2020 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltKeychain
import XCTest

protocol PasswordKeychainTesting: XCTestCase {
    var keychain: Keychain { get }
    var firstPassword: String { get }
    var firstAccount: String { get }
    var secondPassword: String { get }
    var secondAccount: String { get }
}

extension PasswordKeychainTesting {
    func cleanUp(file: StaticString = #file, line: UInt = #line) {
        do {
            try self.keychain.removeAllValues()
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
    
    func savePassword(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch(file: file, line: line) {
            try self.keychain.setValue(self.firstPassword, for: self.firstAccount)
        }
    }
    
    func readPassword(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch(file: file, line: line) {
            try self.keychain.setValue(self.firstPassword, for: self.firstAccount)
            
            guard let passwordData = try keychain.getValue(for: self.firstAccount) else {
                XCTFail("Password data is nil.")
                return
            }
            
            let password = String(data: passwordData, encoding: .utf8)
            
            XCTAssertEqual(self.firstPassword, password, file: file, line: line)
        }
    }
    
    func updatePassword(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch(file: file, line: line) {
            try self.keychain.setValue(self.firstPassword, for: self.firstAccount)
            try self.keychain.setValue(self.secondPassword, for: self.firstAccount)
            
            guard let passwordData = try keychain.getValue(for: self.firstAccount) else {
                XCTFail("Password data is nil.")
                return
            }
            
            let password = String(data: passwordData, encoding: .utf8)
            
            XCTAssertEqual(self.secondPassword, password, file: file, line: line)
        }
    }
    
    func deletePassword(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch(file: file, line: line) {
            try self.keychain.setValue(self.firstPassword, for: self.firstAccount)
            try self.keychain.removeValue(for: self.firstAccount)
            
            XCTAssertNil(try self.keychain.getValue(for: self.firstAccount), file: file, line: line)
        }
    }
    
    func deleteAllPasswords(file: StaticString = #file, line: UInt = #line) {
        self.measureAndCatch(file: file, line: line) {
            try self.keychain.setValue(self.firstPassword, for: self.firstAccount)
            try self.keychain.setValue(self.secondPassword, for: self.secondAccount)
            try self.keychain.removeAllValues()
            
            XCTAssertNil(try self.keychain.getValue(for: self.firstAccount), file: file, line: line)
            XCTAssertNil(try self.keychain.getValue(for: self.secondAccount), file: file, line: line)
        }
    }
}
