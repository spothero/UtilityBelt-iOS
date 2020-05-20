// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
@testable import Lincoln
import XCTest

final class LincolnTests: XCTestCase {
    func testLogging() throws {
        Lincoln.shared.register(self)
        Lincoln.shared.info("Wow")
    }
}

extension LincolnTests: LogHandler {
    func log(_ event: LogEvent) {
        print(event)
    }
}
