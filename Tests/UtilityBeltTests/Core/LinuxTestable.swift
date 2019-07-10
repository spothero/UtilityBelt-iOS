//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
//import XCTest
//
//// Idea sourced from https://oleb.net/blog/2017/03/keeping-xctest-in-sync/
//
//// TODO: This could be moved into a UtilityBelt/Testing library for use across test suites in repos
//
//protocol LinuxTestable {
//    static var allTests: [(String, (Self) -> () throws -> Void)] { get }
//    
//    func testLinuxTestSuiteIncludesAllTests()
//}
//
//extension LinuxTestable where Self: XCTestCase {
//    /// Identifies whether or not all tests are accounted for in the allTests variable, which is used to collect tests for LinuxMain.swift
//    /// If the test counts are inequal between the defaultTestSuite (macOS) and allTests (Linux), an error is thrown
//    func base_testLinuxTestSuiteIncludesAllTests() {
//        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//        let thisClass = type(of: self)
//        let darwinCount = thisClass.defaultTestSuite.testCaseCount
//        let linuxCount = thisClass.allTests.count
//        
//        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
//        #endif
//    }
//}
