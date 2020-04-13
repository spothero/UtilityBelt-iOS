// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
@testable import Sham
import UtilityBeltNetworking
import XCTest

final class StubRequestTests: XCTestCase {
    func testRandomizedQueryStringOrderComparisonSucceeds() {
        let request: StubRequest = .get("https://spothero.local?shape=triangle&color=blue")
        let canMockData = request.canMockData(for: .get("https://spothero.local?color=blue&shape=triangle"))

        XCTAssertTrue(canMockData, "Unable to mock data for request.")
    }
}
