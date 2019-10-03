// Copyright © 2019 SpotHero, Inc. All rights reserved.

import XCTest

import ShamTests
import UtilityBeltNetworkingTests

var tests = [XCTestCaseEntry]()
tests += ShamTests.__allTests()
tests += UtilityBeltNetworkingTests.__allTests()

XCTMain(tests)
