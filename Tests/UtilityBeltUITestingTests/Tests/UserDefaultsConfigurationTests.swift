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
    
    func testInjectIntoUserDefaults() {
        let configuration = UserDefaultsConfiguration()

        // Store objects to be saved in the standard UserDefaults.
        let intKey = "TestInt"
        let intValue = 2
        configuration.storeUserDefaultsObject(UserDefaultsObject(key: intKey, value: .int(intValue)))
        
        // Verify the current UserDefaults.standard doesn't contain the keys we'll inject.
        XCTAssertNil(UserDefaults.standard.value(forKey: intKey))
        
        // Inject the stored objects.
        configuration.injectIntoUserDefaults()
        
        // Verify they were saved in UserDefaults.standard.
        XCTAssertEqual(UserDefaults.standard.value(forKey: intKey) as? Int, intValue)
        
        // Clean up the UserDefaults.
        UserDefaults.standard.removeObject(forKey: intKey)
    }
}
