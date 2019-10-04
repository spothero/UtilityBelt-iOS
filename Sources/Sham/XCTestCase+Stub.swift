// Copyright © 2019 SpotHero, Inc. All rights reserved.

import UtilityBeltNetworking
import XCTest

public extension XCTestCase {
    func stub(_ stubRequest: StubRequest, with response: StubResponse) {
        MockService.shared.stub(stubRequest, with: response)
    }

    func stub(_ urlRequest: URLRequestConvertible, with response: StubResponse) {
        MockService.shared.stub(urlRequest, with: response)
    }
}
