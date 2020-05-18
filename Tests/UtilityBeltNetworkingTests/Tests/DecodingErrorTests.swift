// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking
import XCTest

final class DecodingErrorTests: XCTestCase {
    struct Example: Decodable {
        let array: [String]
        let boolean: Bool
        let float: Float
        let integer: Int
        let string: String
    }
    
    // MARK: Type Mismatch
    
    func testDecodingErrorArrayTypeMismatchCleanup() throws {
        let json = """
        {
            "array": 42,
            "boolean": true,
            "float": 1.21,
            "integer": 42,
            "string": "foo",
        }
        """
        
        // This message outputs Array<Any> instead of Array<String>
        // Once the decoder has a valid array, it will then put out error messages based on the Element type
        let expectedMessage = "Type mismatch for key 'array'. Expected type 'Array<Any>'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    func testDecodingErrorArrayItemTypeMismatchCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                1
            ],
            "boolean": true,
            "float": 1.21,
            "integer": 42,
            "string": "foo",
        }
        """
        
        let expectedMessage = "Type mismatch for key 'array[1]'. Expected type 'String'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    func testDecodingErrorBoolTypeMismatchCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                "bar"
            ],
            "boolean": "true",
            "float": 1.21,
            "integer": 42,
            "string": "foo",
        }
        """
        
        let expectedMessage = "Type mismatch for key 'boolean'. Expected type 'Bool'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    func testDecodingErrorFloatTypeMismatchCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                "bar"
            ],
            "boolean": true,
            "float": "42.0",
            "integer": 42,
            "string": "foo",
        }
        """
        
        let expectedMessage = "Type mismatch for key 'float'. Expected type 'Float'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    func testDecodingErrorIntTypeMismatchCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                "bar"
            ],
            "boolean": true,
            "float": 1.21,
            "integer": "42",
            "string": "foo",
        }
        """
        
        let expectedMessage = "Type mismatch for key 'integer'. Expected type 'Int'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    func testDecodingErrorStringTypeMismatchCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                "bar"
            ],
            "boolean": true,
            "float": 1.21,
            "integer": 42,
            "string": 0,
        }
        """
        
        let expectedMessage = "Type mismatch for key 'string'. Expected type 'String'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    // MARK: Value Not Found
    
    func testDecodingErrorArrayValueNotFoundCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                null
            ],
            "boolean": true,
            "float": 1.21,
            "integer": 42,
            "string": null
        }
        """
        
        let expectedMessage = "Value not found for key 'array[1]' of type 'String'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    func testDecodingErrorStringValueNotFoundCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                "bar"
            ],
            "boolean": true,
            "float": 1.21,
            "integer": 42,
            "string": null
        }
        """
        
        let expectedMessage = "Value not found for key 'string' of type 'String'."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    // MARK: Key Not Found
    
    func testDecodingErrorKeyNotFoundCleanup() throws {
        let json = """
        {
            "array": [
                "foo",
                "bar"
            ],
            "boolean": true,
            "float": 1.21,
            "integer": 42,
        }
        """
        
        let expectedMessage = "Key 'string' not found."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    // MARK: Data Corrupted
    
    func testDecodingErrorDataCorruptedCleanup() throws {
        // An empty JSON string is enough to showcase corrupted data
        let json = ""
        
        let expectedMessage = "Data corrupted."
        
        self.decode(json, withExpectedMessage: expectedMessage)
    }
    
    private func decode(_ json: String, withExpectedMessage expectedMessage: String, file: StaticString = #file, line: UInt = #line) {
        // We don't care about force unwrapping in tests, we want to know if this fails
        // swiftlint:disable:next force_unwrapping
        let jsonData = json.data(using: .utf8)!
        
        do {
            _ = try JSONDecoder().decode(Example.self, from: jsonData)
            XCTFail("Decoding succeeded, expected failure to test decoding error message cleanup.", file: file, line: line)
        } catch let decodingError as DecodingError {
            XCTAssertEqual(decodingError.cleanedDescription, expectedMessage, file: file, line: line)
        } catch {
            XCTFail("Invalid error type!", file: file, line: line)
        }
    }
}
