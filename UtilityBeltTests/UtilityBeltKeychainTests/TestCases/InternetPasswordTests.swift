// Copyright © 2020 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltKeychain
import XCTest

class InternetPasswordTests: XCTestCase, PasswordKeychainTesting {
    var keychain = Keychain(server: "someServer",
                            protocol: .https,
                            authenticationType: .httpBasic,
                            path: "somePath",
                            port: 8080,
                            securityDomain: "someDomain")
    
    var firstPassword = "pwd_1234"
    var firstAccount = "internetPassword"
    
    var secondPassword = "pwd_1235"
    var secondAccount = "internetPassword2"
    
    override func tearDown() {
        self.cleanUp()
        
        super.tearDown()
    }
    
    func testSaveInternetPassword() {
        self.savePassword()
    }
    
    func testReadInternetPassword() {
        self.readPassword()
    }
    
    func testUpdateInternetPassword() {
        self.updatePassword()
    }
    
    func testDeleteInternetPassword() {
        self.deletePassword()
    }
    
    func testDeleteAllInternetPasswords() {
        self.deleteAllPasswords()
    }
}
