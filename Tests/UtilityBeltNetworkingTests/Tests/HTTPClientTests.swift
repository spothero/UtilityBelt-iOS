// Copyright © 2019 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltNetworking

import XCTest

final class HTTPClientTests: XCTestCase {
    func testNonsense() {
        HTTPClient.shared.request(url: "https://google.com")
            .host("google.com")
            .scheme("https")
            .response { (_: DecodableResult<String>) in
            }
    }
}
