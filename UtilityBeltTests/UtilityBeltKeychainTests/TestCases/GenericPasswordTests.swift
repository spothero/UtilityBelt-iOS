// Copyright © 2020 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltKeychain
import XCTest

class GenericPasswordTests: XCTestCase, PasswordKeychainTesting {
    var keychain = Keychain(service: "MyService")
    
    var firstPassword = "pwd_1234"
    var firstAccount = "genericPassword"
    
    var secondPassword = "pwd_1235"
    var secondAccount = "genericPassword2"
    
    override func tearDown() {
        self.cleanUp()
        
        super.tearDown()
    }
    
    func testSaveGenericPassword() {
        self.savePassword()
    }
    
    func testReadGenericPassword() {
        self.readPassword()
    }
    
    func testUpdateGenericPassword() {
        self.updatePassword()
    }
    
    func testDeleteGenericPassword() {
        self.deletePassword()
    }
    
    func testDeleteAllGenericPasswords() {
        self.deleteAllPasswords()
    }
}
