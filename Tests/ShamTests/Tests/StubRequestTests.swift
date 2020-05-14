// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
@testable import Sham
import UtilityBeltNetworking
import XCTest

final class StubRequestTests: XCTestCase {
    
    private let baseURLString = "https://spothero.local"
    
    func testDescriptionWithUnsortedParameters() {
        let unsortedQueryParametersURL = "\(self.baseURLString)?zebra=thing&ardvark=other_thing"
        let request: StubRequest = .get(unsortedQueryParametersURL)
        
        let sortedQueryParametersURL = "\(self.baseURLString)?ardvark=other_thing&zebra=thing"
        XCTAssertEqual(request.description, "get: \(sortedQueryParametersURL)")
    }
    
    func testDescriptionWithNoParameters() {
        let request: StubRequest = .post(self.baseURLString)
        XCTAssertEqual(request.description, "post: \(self.baseURLString)")
    }
    
    func testDescriptionWithNoMethod() {
        let request = StubRequest(url: self.baseURLString)
        XCTAssertEqual(request.description, "ALL: \(self.baseURLString)")
    }
}
