import XCTest

import ShamTests
import UtilityBeltNetworkingTests

var tests = [XCTestCaseEntry]()
tests += ShamTests.__allTests()
tests += UtilityBeltNetworkingTests.__allTests()

XCTMain(tests)
