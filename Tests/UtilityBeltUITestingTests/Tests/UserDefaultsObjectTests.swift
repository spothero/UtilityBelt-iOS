// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltUITesting
import XCTest

final class UserDefaultsObjectTests: XCTestCase {
    func testEncodingAndDecodingValues() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // Bool
        let boolValue = UserDefaultsObject.Value.bool(true)
        let encodedBoolValue = try encoder.encode(boolValue)
        let decodedBoolValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedBoolValue)
        XCTAssertEqual(decodedBoolValue, boolValue)
        
        // Data
        let stringData = try XCTUnwrap("testing".data(using: .utf8))
        let dataValue = UserDefaultsObject.Value.data(stringData)
        let encodedDataValue = try encoder.encode(dataValue)
        let decodedDataValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedDataValue)
        XCTAssertEqual(decodedDataValue, dataValue)
        
        // Date
        let dateValue = UserDefaultsObject.Value.date(Date())
        let encodedDateValue = try encoder.encode(dateValue)
        let decodedDateValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedDateValue)
        XCTAssertEqual(decodedDateValue, dateValue)
        
        // Double
        let doubleValue = UserDefaultsObject.Value.double(1.1)
        let encodedDoubleValue = try encoder.encode(doubleValue)
        let decodedDoubleValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedDoubleValue)
        XCTAssertEqual(decodedDoubleValue, doubleValue)
        
        // Float
        let floatValue = UserDefaultsObject.Value.float(1.1)
        let encodedFloatValue = try encoder.encode(floatValue)
        let decodedFloatValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedFloatValue)
        XCTAssertEqual(decodedFloatValue, floatValue)
        
        // Int
        let intValue = UserDefaultsObject.Value.int(1)
        let encodedIntValue = try encoder.encode(intValue)
        let decodedIntValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedIntValue)
        XCTAssertEqual(decodedIntValue, intValue)
        
        // String
        let stringValue = UserDefaultsObject.Value.string("Testing")
        let encodedStringValue = try encoder.encode(stringValue)
        let decodedStringValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedStringValue)
        XCTAssertEqual(decodedStringValue, stringValue)
        
        // UInt
        let uintValue = UserDefaultsObject.Value.uint(1)
        let encodedUIntValue = try encoder.encode(uintValue)
        let decodedUIntValue = try decoder.decode(UserDefaultsObject.Value.self, from: encodedUIntValue)
        XCTAssertEqual(decodedUIntValue, uintValue)
    }
}
