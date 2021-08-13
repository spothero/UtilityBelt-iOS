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
    
    func testAccuratelyValidatesWhenAStubHasASubsetOfAnotherStubsQueryParameters() {
        // GIVEN: A stub with many query parameters.
        let queryParametersURL = "\(self.baseURLString)?zebra=thing&aardvark=other_thing&giraffe=thing_3"
        let stub: StubRequest = .get(queryParametersURL)
        
        // GIVEN: A stub with a subset of the previous URL's parameters and set to allowing missing query parameters.
        let similarURL = "\(self.baseURLString)?aardvark=other_thing&zebra=thing"
        let querySubsetStub: StubRequest = .get(similarURL, queryMatchRule: .allowMissingQueryParameters)
        
        // THEN: The subset stub has all provided query items for the stub.
        XCTAssertTrue(querySubsetStub.hasSubsetOfQueryItems(in: stub))
    }
    
    func testAccuratelyValidatesWhenAStubDoesNotHaveASubsetOfAnotherStubsQueryParameters() {
        // GIVEN: A stub with a subset of parameters.
        let similarURL = "\(self.baseURLString)?aardvark=other_thing&zebra=thing"
        let stub: StubRequest = .get(similarURL)
        
        // GIVEN: A stub with a superset of query parameters and set to allow missing query parameters.
        let queryParametersURL = "\(self.baseURLString)?zebra=thing&aardvark=other_thing&giraffe=thing_3"
        let querySupersetStub: StubRequest = .get(queryParametersURL, queryMatchRule: .allowMissingQueryParameters)
        
        // THEN: The stub does not have all provided query items for the superset stub.
        XCTAssertFalse(querySupersetStub.hasSubsetOfQueryItems(in: stub))
    }
    
    func testDifferentCasedURLPathsStillMatch() {
        let endpointString = "/aardvark=other_thing&zebra=thing"
        
        // GIVEN: A StubRequest with a lowercased path
        let lowercasedStub: StubRequest = .get("\(self.baseURLString)\(endpointString.lowercased())")
        
        // GIVEN: A StubRequest with the same endpoint but with uppercased letters
        let uppercasedStub: StubRequest = .get("\(self.baseURLString)\(endpointString.uppercased())")
        
        // THEN: The lowercased StubRequest can still mock data for the uppercased StubRequest.
        XCTAssertTrue(lowercasedStub.canMockData(for: uppercasedStub))
    }
}
