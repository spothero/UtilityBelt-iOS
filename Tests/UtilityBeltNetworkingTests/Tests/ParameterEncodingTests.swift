// Copyright © 2020 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltNetworking
import XCTest

final class ParameterEncodingTests: XCTestCase {
    private var parameters: [String: Any] = [
        "bool": true,
        "double": 2.5,
        "integer": 1,
        "string": "foo",
        "dictionary": [
            "bool": true,
            "double": 2.5,
            "integer": 1,
            "string": "foo",
            "dictionary": [
                "bool": true,
                "double": 2.5,
                "integer": 1,
                "string": "foo",
            ],
            "array": [
                "alice",
                "bob",
                "carol",
            ],
        ],
        "array": [
            "alice",
            "bob",
            "carol",
        ],
    ]
    
    func testPostDefaultRequest() {
        // GIVEN: I create a POST request.
        guard let request = try? self.request(withMethod: .post) else {
            assertionFailure("Failed to create request.")
            return
        }
        
        // THEN: The body contains the serialized data.
        self.dataIsInBody(request: request)
    }
    
    func testPostQueryRequest() {
        // GIVEN: I create a POST request with query encoding.
        guard let request = try? self.request(withMethod: .post, encoding: .queryString) else {
            assertionFailure("Failed to create request.")
            return
        }
        
        // THEN: The query contains the serialized data.
        self.queryIsInParams(request: request)
    }
    
    func testPostFormRequest() {
        // GIVEN: I create a POST request with form encoding.
        guard let request = try? self.request(withMethod: .post, encoding: .httpBody(.wwwFormURLEncoded)) else {
            assertionFailure("Failed to create request.")
            return
        }
        
        // THEN: The body contains the serialized data.
        self.queryIsInBody(request: request)
    }
    
    func testGetDefaultRequest() {
        // GIVEN: I create a GET request.
        guard let request = try? self.request(withMethod: .get) else {
            assertionFailure("Failed to create request.")
            return
        }
        
        // THEN: The query contains the serialized data.
        self.queryIsInParams(request: request)
    }
    
    func testDeleteDefaultRequest() {
        // GIVEN: I create a DELETE request.
        guard let request = try? self.request(withMethod: .delete) else {
            assertionFailure("Failed to create request.")
            return
        }
        
        // THEN: The query contains the serialized data.
        self.queryIsInParams(request: request)
    }
    
    func testPutDefaultRequest() {
        // GIVEN: I create a PUT request.
        guard let request = try? self.request(withMethod: .put) else {
            assertionFailure("Failed to create request.")
            return
        }
        
        // THEN: The body contains the serialized data.
        self.dataIsInBody(request: request)
    }
    
    func testPatchDefaultRequest() {
        // GIVEN: I create a PATCH request.
        guard let request = try? self.request(withMethod: .patch) else {
            assertionFailure("Failed to create request.")
            return
        }
        
        // THEN: The body contains the serialized data.
        self.dataIsInBody(request: request)
    }
    
    /// Helper to create a request.
    /// - Parameters:
    ///   - method: The HTTP method for the request.
    ///   - encoding: The encoding for the parameters
    /// - Throws: If there's an error creating the request.
    /// - Returns: The URLRequest
    private func request(withMethod method: HTTPMethod, encoding: ParameterEncoding? = nil) throws -> URLRequest {
        let url = try "spothero.com".asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.setParameters(self.parameters, method: method, encoding: encoding)
        
        return request
    }
    
    /// Asserts that the parameters are data in the request body.
    /// - Parameter request: The request to check.
    private func dataIsInBody(request: URLRequest) {
        let jsonSerialized: Data
        if #available(OSX 10.13, *) {
            guard let serialized = try? JSONSerialization.data(withJSONObject: self.parameters, options: .sortedKeys) else {
                assertionFailure("Failed to serialized mocked parameters")
                return
            }
            jsonSerialized = serialized
        } else {
            guard let serialized = try? JSONSerialization.data(withJSONObject: self.parameters, options: []) else {
                assertionFailure("Failed to serialized mocked parameters")
                return
            }
            jsonSerialized = serialized
        }
        
        XCTAssertEqual(request.httpBody, jsonSerialized)
    }
    
    /// Asserts that the parameters are a query in the request body.
    /// - Parameter request: The request to check.
    private func queryIsInBody(request: URLRequest) {
        var components = URLComponents()
        components.setQueryItems(with: self.parameters)
        guard let testQueryData = components.percentEncodedQuery?.data(using: .utf8) else {
            assertionFailure("Failed to create test query.")
            return
        }
        
        XCTAssertEqual(request.httpBody, testQueryData)
    }
    
    /// Asserts that the parameters are a query on the request.
    /// - Parameter request: The request to check.
    private func queryIsInParams(request: URLRequest) {
        guard let requestQuery = request.url?.query else {
            assertionFailure("Failed to get request query.")
            return
        }
        
        var components = URLComponents()
        components.setQueryItems(with: self.parameters)
        guard let testQuery = components.percentEncodedQuery else {
            assertionFailure("Failed to create test query.")
            return
        }
        
        XCTAssertEqual(requestQuery, testQuery, "Query is incorrect.")
    }
}
