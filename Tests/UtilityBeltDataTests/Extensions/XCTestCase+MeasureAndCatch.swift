// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import XCTest

extension XCTestCase {
    func measureAndCatch(file: StaticString = #file,
                         line: UInt = #line,
                         block: () throws -> Void) {
        self.measure {
            do {
                try block()
            } catch {
                XCTFail(error.localizedDescription, file: file, line: line)
            }
        }
    }
}
