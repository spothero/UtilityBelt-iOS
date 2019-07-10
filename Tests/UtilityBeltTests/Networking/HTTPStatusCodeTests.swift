//
//  HTTPStatusCodeTests.swift
//  
//
//  Created by Brian Drelling on 6/12/19.
//

@testable import UtilityBelt
import XCTest

final class HTTPStatusCodeTests: XCTestCase {
    func testResponseTypes() {
        // Test response types for every status code
        for code in HTTPStatusCode.allCases {
            // None that we currently work with should be undefined
            XCTAssertNotEqual(code.responseType, .undefined)
            
            switch code.rawValue {
            case Int.min..<100:
                XCTFail("Status codes should not be less than 100.")
            case 100..<200:
                XCTAssertEqual(code.responseType, .informational)
            case 200..<300:
                XCTAssertEqual(code.responseType, .success)
            case 300..<400:
                XCTAssertEqual(code.responseType, .redirection)
            case 400..<500:
                XCTAssertEqual(code.responseType, .clientError)
            case 500..<600:
                XCTAssertEqual(code.responseType, .serverError)
            case 600..<Int.max:
                XCTFail("Status codes should not be greater than or equal to 600.")
            default:
                XCTFail("Status code is outside of the possible integer range. How did that happen?")
            }
        }
    }
}
