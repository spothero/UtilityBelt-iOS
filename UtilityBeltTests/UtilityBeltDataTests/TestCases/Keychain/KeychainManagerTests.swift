// Copyright © 2019 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltData
import XCTest

class KeychainManagerTests: XCTestCase {
    var secureStoreWithGenericPwd: SecureStore!
    var secureStoreWithInternetPwd: SecureStore!

    override func setUp() {
        super.setUp()

        let genericPwdQueryable = GenericPasswordQueryable(service: "MyService")
        secureStoreWithGenericPwd = SecureStore(secureStoreQueryable: genericPwdQueryable)

        let internetPwdQueryable = InternetPasswordQueryable(server: "someServer",
                                                             port: 8080,
                                                             path: "somePath",
                                                             securityDomain: "someDomain",
                                                             internetProtocol: .https,
                                                             internetAuthenticationType: .httpBasic)
        secureStoreWithInternetPwd = SecureStore(secureStoreQueryable: internetPwdQueryable)
    }

    override func tearDown() {
        try? self.secureStoreWithGenericPwd.removeAllValues()
        try? self.secureStoreWithInternetPwd.removeAllValues()

        super.tearDown()
    }

    func testSaveGenericPassword() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
        } catch let e {
            XCTFail("Saving generic password failed with \(e.localizedDescription).")
        }
    }

    func testReadGenericPassword() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
            XCTAssertEqual("pwd_1234", password)
        } catch let e {
            XCTFail("Reading generic password failed with \(e.localizedDescription).")
        }
    }

    func testUpdateGenericPassword() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            try self.secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword")
            let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
            XCTAssertEqual("pwd_1235", password)
        } catch let e {
            XCTFail("Updating generic password failed with \(e.localizedDescription).")
        }
    }

    func testRemoveGenericPassword() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            try self.secureStoreWithGenericPwd.removeValue(for: "genericPassword")
            XCTAssertNil(try self.secureStoreWithGenericPwd.getValue(for: "genericPassword"))
        } catch let e {
            XCTFail("Saving generic password failed with \(e.localizedDescription).")
        }
    }

    func testRemoveAllGenericPasswords() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            try self.secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword2")
            try self.secureStoreWithGenericPwd.removeAllValues()
            XCTAssertNil(try self.secureStoreWithGenericPwd.getValue(for: "genericPassword"))
            XCTAssertNil(try self.secureStoreWithGenericPwd.getValue(for: "genericPassword2"))
        } catch let e {
            XCTFail("Removing generic passwords failed with \(e.localizedDescription).")
        }
    }

    func testSaveInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
        } catch let e {
            XCTFail("Saving Internet password failed with \(e.localizedDescription).")
        }
    }

    func testReadInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            let password = try secureStoreWithInternetPwd.getValue(for: "internetPassword")
            XCTAssertEqual("pwd_1234", password)
        } catch let e {
            XCTFail("Reading Internet password failed with \(e.localizedDescription).")
        }
    }

    func testUpdateInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            try self.secureStoreWithInternetPwd.setValue("pwd_1235", for: "internetPassword")
            let password = try secureStoreWithInternetPwd.getValue(for: "internetPassword")
            XCTAssertEqual("pwd_1235", password)
        } catch let e {
            XCTFail("Updating Internet password failed with \(e.localizedDescription).")
        }
    }

    func testRemoveInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            try self.secureStoreWithInternetPwd.removeValue(for: "internetPassword")
            XCTAssertNil(try self.secureStoreWithInternetPwd.getValue(for: "internetPassword"))
        } catch let e {
            XCTFail("Removing Internet password failed with \(e.localizedDescription).")
        }
    }

    func testRemoveAllInternetPasswords() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            try self.secureStoreWithInternetPwd.setValue("pwd_1235", for: "internetPassword2")
            try self.secureStoreWithInternetPwd.removeAllValues()
            XCTAssertNil(try self.secureStoreWithInternetPwd.getValue(for: "internetPassword"))
            XCTAssertNil(try self.secureStoreWithInternetPwd.getValue(for: "internetPassword2"))
        } catch let e {
            XCTFail("Removing Internet passwords failed with \(e.localizedDescription).")
        }
    }
}
