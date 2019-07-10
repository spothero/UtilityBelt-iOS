// Copyright © 2019 SpotHero, Inc. All rights reserved.

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(UtilityBelt_iOSTests.allTests),
        ]
    }
#endif
