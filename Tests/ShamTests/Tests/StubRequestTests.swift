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
    
    // MARK: Query items tests
    
    func testAccuratelyValidatesWhenARequestHasAllQueryItems() {
        // GIVEN: A request with many parameters.
        let queryParametersURL = "\(self.baseURLString)?zebra=thing&aardvark=other_thing&giraffe=thing_3"
        let request: StubRequest = .get(queryParametersURL)
        
        // GIVEN: A stub with a subset of the previous URL's parameters and set to allowing missing query parameters.
        let similarURL = "\(self.baseURLString)?aardvark=other_thing&zebra=thing"
        let stub: StubRequest = .get(similarURL, validationRule: .allowMissingQueryParameters)
        
        // THEN: The stub has all provided query items for the request.
        XCTAssertTrue(stub.hasAllProvidedQueryItems(for: request))
    }
    
    func testAccuratelyValidatesWhenARequestDoesNotHaveAllQueryItems() {
        // GIVEN: A stub with many parameters.
        let queryParametersURL = "\(self.baseURLString)?zebra=thing&aardvark=other_thing&giraffe=thing_3"
        let stub: StubRequest = .get(queryParametersURL, validationRule: .allowMissingQueryParameters)
        
        // GIVEN: A stub with a subset of the previous URL's parameters and set to not allow missing query parameters.
        let similarURL = "\(self.baseURLString)?aardvark=other_thing&zebra=thing"
        let request: StubRequest = .get(similarURL)
        
        // THEN: The stub does not have all provided query items for the request.
        XCTAssertFalse(stub.hasAllProvidedQueryItems(for: request))
    }
}
