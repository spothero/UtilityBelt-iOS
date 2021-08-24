// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking
import XCTest

final class RequestTimeoutTests: XCTestCase {
    func testNilTimeoutIntervalValue() throws {
        // A request is created and the timeout is set to nil.
        var request = try self.createSimpleTestRequest()
        request.setTimeout(nil)
        
        // The timeout on the request should be the default value of 60 seconds.
        XCTAssertEqual(request.timeoutInterval, 60)
    }
    
    func testCustomTimeoutIntervalValue() throws {
        // A new timeout of 1 for testing.
        let timeout = TimeInterval(1)
        
        // A request is created and the timeout is set to 1.
        var request = try self.createSimpleTestRequest()
        request.setTimeout(timeout)
        
        // The timeout interval on the request should be the same as the timeout.
        XCTAssertEqual(request.timeoutInterval, timeout)
    }
}

private extension RequestTimeoutTests {
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
