// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
@testable import Sham
import UtilityBeltNetworking
import XCTest

final class StubRequestTests: XCTestCase {
    private let baseURLString = "https://spothero.local"
    
    func testDescriptionWithUnsortedParameters() {
        let unsortedQueryParametersURL = "\(self.baseURLString)?zebra=thing&aardvark=other_thing"
        let request: StubRequest = .get(unsortedQueryParametersURL)
        
        let sortedQueryParametersURL = "\(self.baseURLString)?aardvark=other_thing&zebra=thing"
        XCTAssertEqual(request.description, "GET: \(sortedQueryParametersURL)")
    }
    
    func testDescriptionWithNoParameters() {
        let request: StubRequest = .post(self.baseURLString)
        XCTAssertEqual(request.description, "POST: \(self.baseURLString)")
    }
    
    func testDescriptionWithNoMethod() {
        let request = StubRequest(url: self.baseURLString)
        XCTAssertEqual(request.description, "ALL: \(self.baseURLString)")
    }
    
    func testAccuratelyCountsMatchingQueryParameters() {
        let queryParametersURL = "\(self.baseURLString)?zebra=thing&aardvark=other_thing&giraffe=thing_3"
        let request1: StubRequest = .get(queryParametersURL)
        
        let similarURL = "\(self.baseURLString)?aardvark=other_thing&zebra=thing"
        let request2: StubRequest = .get(similarURL)
        
        XCTAssertEqual(2, request1.matchingParameterCount(for: request2))
    }
}
