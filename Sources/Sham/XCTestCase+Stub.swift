// Copyright © 2019 SpotHero, Inc. All rights reserved.

import XCTest

public extension XCTestCase {
    func stub(_ stubRequest: StubRequest, with response: StubResponse) {
        MockService.shared.stub(stubRequest, with: response)
    }

    func stub(_ urlRequest: URLRequest, with response: StubResponse) {
        MockService.shared.stub(urlRequest, with: response)
    }

    func stub(_ url: URL, with response: StubResponse) {
        MockService.shared.stub(url, with: response)
    }

    func stub(_ urlString: String, with response: StubResponse) {
        MockService.shared.stub(urlString, with: response)
    }
}
