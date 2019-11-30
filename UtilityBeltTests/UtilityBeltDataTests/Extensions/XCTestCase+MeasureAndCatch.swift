// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import XCTest

extension XCTestCase {
    func measureAndCatch(file: StaticString = #file,
                         line: UInt = #line,
                         block: () throws -> Void) {
        measure {
            do {
                try block()
            } catch {
                XCTFail(error.localizedDescription, file: file, line: line)
            }
        }
    }
}
