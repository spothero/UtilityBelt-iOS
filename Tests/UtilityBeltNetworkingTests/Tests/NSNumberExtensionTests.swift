// Copyright © 2021 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltNetworking
import XCTest

class NSNumberExtensionTests: XCTestCase {
    func testIsBoolean() {
        // WHEN: I have a boolean NSNumber
        let booleanNSNumber = NSNumber(false)
        // THEN: The `isBoolean` property will return true.
        XCTAssertTrue(booleanNSNumber.isBoolean)
        
        // WHEN: I have a boolean NSNumber
        let integerNSNumber = NSNumber(1)
        // THEN: The `isBoolean` property will return false.
        XCTAssertFalse(integerNSNumber.isBoolean)
    }
}
