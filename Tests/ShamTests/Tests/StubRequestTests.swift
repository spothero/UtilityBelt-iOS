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
}
