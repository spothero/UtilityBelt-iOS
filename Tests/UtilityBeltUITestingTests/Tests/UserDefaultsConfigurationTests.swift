// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltUITesting
import XCTest

final class UserDefaultsConfigurationTests: XCTestCase {
    // MARK: Tests
    
    func testStoringStandardDefaultsObject() throws {
        let configuration = UserDefaultsConfiguration()

        // Verify there are no user default objects upon initialization.
        XCTAssertTrue(configuration.standard.isEmpty)
        XCTAssertTrue(configuration.customSuites.isEmpty)

        // Verify calling storeUserDefaultsObject(_:) updates the standard array.
        configuration.storeUserDefaultsObject(UserDefaultsObject(key: "Testing", value: .int(1)))
        XCTAssertEqual(configuration.standard.count, 1)
        XCTAssertTrue(configuration.customSuites.isEmpty)
        
        let firstObject = try XCTUnwrap(configuration.standard.first)
        XCTAssertEqual(firstObject.key, "Testing")
        XCTAssertEqual(firstObject.value, .int(1))
    }

    func testStoringCustomSuiteObject() throws {
        let configuration = UserDefaultsConfiguration()

        // Verify there are no user default objects upon initialization.
        XCTAssertTrue(configuration.standard.isEmpty)
        XCTAssertTrue(configuration.customSuites.isEmpty)

        // Verify calling storeUserDefaultsObject(_: inSuite:) updates the custom suites dictionary.
        configuration.storeUserDefaultsObject(UserDefaultsObject(key: "Testing", value: .int(1)), inSuite: "TestSuite")
        XCTAssertEqual(configuration.customSuites.keys.count, 1)
        XCTAssertTrue(configuration.standard.isEmpty)
                
        let firstSuiteKey = try XCTUnwrap(configuration.customSuites.keys.first)
        XCTAssertEqual(firstSuiteKey, "TestSuite")
        
        let firstSuiteObjects = try XCTUnwrap(configuration.customSuites[firstSuiteKey])
        XCTAssertEqual(firstSuiteObjects.count, 1)
        
        let firstObject = try XCTUnwrap(firstSuiteObjects.first)
        XCTAssertEqual(firstObject.key, "Testing")
        XCTAssertEqual(firstObject.value, .int(1))
    }
    
    func testInjectIntoUserDefaults() throws {
        let configuration = UserDefaultsConfiguration()

        // Store objects to be saved in the both the standard and custom UserDefaults.
        let dateKey = "TestDate"
        let dateValue = Date()
        let dateObject = UserDefaultsObject(key: dateKey, value: .date(dateValue))
        configuration.storeUserDefaultsObject(dateObject)
        
        let suiteName = "TestSuite"
        configuration.storeUserDefaultsObject(dateObject, inSuite: suiteName)
                
        // Verify the UserDefaults do not contain the keys we'll inject.
        XCTAssertNil(UserDefaults.standard.value(forKey: dateKey))
        let customDefaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        XCTAssertNil(customDefaults.value(forKey: dateKey))
        
        // Inject the stored objects.
        configuration.injectIntoUserDefaults()
        
        // Verify the object was saved in UserDefaults.standard.
        XCTAssertEqual(UserDefaults.standard.value(forKey: dateKey) as? Date, dateValue)
        
        // Verify the object was saved in the custom suite.
        XCTAssertEqual(customDefaults.value(forKey: dateKey) as? Date, dateValue)

        // Clean up the UserDefaults.
        UserDefaults.standard.removeObject(forKey: dateKey)
        customDefaults.removeObject(forKey: dateKey)
    }
}
