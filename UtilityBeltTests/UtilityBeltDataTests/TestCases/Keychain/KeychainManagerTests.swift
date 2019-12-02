// Copyright © 2019 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltData
import XCTest

class KeychainManagerTests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var secureStoreWithGenericPwd: SecureStore!

    // swiftlint:disable:next implicitly_unwrapped_optional
    var secureStoreWithInternetPwd: SecureStore!

    override func setUp() {
        super.setUp()

        let genericPwdQueryable = GenericPasswordQueryable(service: "MyService")
        secureStoreWithGenericPwd = SecureStore(secureStoreQueryable: genericPwdQueryable)

        let internetPwdQueryable = InternetPasswordQueryable(authenticationType: .httpBasic,
                                                             path: "somePath",
                                                             port: 8080,
                                                             protocol: .https,
                                                             securityDomain: "someDomain",
                                                             server: "someServer")
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
        } catch {
            XCTFail("Saving generic password failed with \(error.localizedDescription).")
        }
    }

    func testReadGenericPassword() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
            XCTAssertEqual("pwd_1234", password)
        } catch {
            XCTFail("Reading generic password failed with \(error.localizedDescription).")
        }
    }

    func testUpdateGenericPassword() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            try self.secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword")
            let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
            XCTAssertEqual("pwd_1235", password)
        } catch {
            XCTFail("Updating generic password failed with \(error.localizedDescription).")
        }
    }

    func testRemoveGenericPassword() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            try self.secureStoreWithGenericPwd.removeValue(for: "genericPassword")
            XCTAssertNil(try self.secureStoreWithGenericPwd.getValue(for: "genericPassword"))
        } catch {
            XCTFail("Saving generic password failed with \(error.localizedDescription).")
        }
    }

    func testRemoveAllGenericPasswords() {
        do {
            try self.secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
            try self.secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword2")
            try self.secureStoreWithGenericPwd.removeAllValues()
            XCTAssertNil(try self.secureStoreWithGenericPwd.getValue(for: "genericPassword"))
            XCTAssertNil(try self.secureStoreWithGenericPwd.getValue(for: "genericPassword2"))
        } catch {
            XCTFail("Removing generic passwords failed with \(error.localizedDescription).")
        }
    }

    func testSaveInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
        } catch {
            XCTFail("Saving Internet password failed with \(error.localizedDescription).")
        }
    }

    func testReadInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            let password = try secureStoreWithInternetPwd.getValue(for: "internetPassword")
            XCTAssertEqual("pwd_1234", password)
        } catch {
            XCTFail("Reading Internet password failed with \(error.localizedDescription).")
        }
    }

    func testUpdateInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            try self.secureStoreWithInternetPwd.setValue("pwd_1235", for: "internetPassword")
            let password = try secureStoreWithInternetPwd.getValue(for: "internetPassword")
            XCTAssertEqual("pwd_1235", password)
        } catch {
            XCTFail("Updating Internet password failed with \(error.localizedDescription).")
        }
    }

    func testRemoveInternetPassword() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            try self.secureStoreWithInternetPwd.removeValue(for: "internetPassword")
            XCTAssertNil(try self.secureStoreWithInternetPwd.getValue(for: "internetPassword"))
        } catch {
            XCTFail("Removing Internet password failed with \(error.localizedDescription).")
        }
    }

    func testRemoveAllInternetPasswords() {
        do {
            try self.secureStoreWithInternetPwd.setValue("pwd_1234", for: "internetPassword")
            try self.secureStoreWithInternetPwd.setValue("pwd_1235", for: "internetPassword2")
            try self.secureStoreWithInternetPwd.removeAllValues()
            XCTAssertNil(try self.secureStoreWithInternetPwd.getValue(for: "internetPassword"))
            XCTAssertNil(try self.secureStoreWithInternetPwd.getValue(for: "internetPassword2"))
        } catch {
            XCTFail("Removing Internet passwords failed with \(error.localizedDescription).")
        }
    }
}
