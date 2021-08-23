// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking
import XCTest

final class HTTPClientTests: XCTestCase {
    func testNilTimeoutIntervalValue() throws {
        let client = HTTPClient.shared
        client.timeoutInterval = nil
        
        // The timeout interval should be nil.
        XCTAssertNil(client.timeoutInterval)
        
        // A request is made on an HTTPClient with no timeout set.
        let request = try client.createSimpleTestRequest()
        
        // The timeout on the request should be the default value of 60 seconds.
        XCTAssertEqual(request.timeoutInterval, 60)
    }
    
    func testCustomTimeoutIntervalValue() throws {
        // An HTTP client is created.
        let client = HTTPClient.shared
        
        // The timeout is set on the client.
        let timeout = TimeInterval(1)
        client.timeoutInterval = timeout
        
        // A request is made on the HTTPClient.
        let request = try client.createSimpleTestRequest()
        
        // The timeout interval on the request should be the same as the timeout.
        XCTAssertEqual(request.timeoutInterval, timeout)
    }
}

private extension HTTPClient {
    // Creates a simple URL request.
    func createSimpleTestRequest() throws -> URLRequest {
        let url = try XCTUnwrap("https://www.spothero.com".asURL())
        let request = try URLRequest(
            url: url,
            method: .get,
            parameters: nil,
            headers: nil,
            encoding: nil
        )
        return request
    }
}
