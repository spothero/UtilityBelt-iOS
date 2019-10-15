// Copyright © 2019 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltNetworking

import XCTest

final class HTTPClientTests: XCTestCase {
    func testGetRequest() {
        HTTPClient.shared.request(url: "https://postman-echo.com")
            .path("get")
    }

    func testNonsense() {
        HTTPClient.shared.request(url: "https://google.com")
            .host("google.com")
            .scheme("https")
            .response { (_: DecodableResult<String>) in
            }
    }
}
