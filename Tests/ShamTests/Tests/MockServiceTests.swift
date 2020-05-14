// Copyright © 2020 SpotHero, Inc. All rights reserved.

@testable import Sham
import UtilityBeltNetworking
import XCTest

final class MockServiceTests: XCTestCase {
    let fullURL = "https://foo.com/foo?foo=bar"
    let schemeOnlyURL = "https://"
    let hostOnlyURL = "//foo.com"
    let pathOnlyURL = "/foo"
    let queryOnlyURL = "?foo=bar"
    
    let mockData = ["foo", "bar"]
    
    override func setUp() {
        super.setUp()
        
        MockService.shared.register()
    }
    
    override func tearDown() {
        super.tearDown()
        
        MockService.shared.clearData()
    }
    
    func testStubbingSameURL() {
        // TODO: This was for development, but it's something we should build out better tests for.
        
        self.stub(self.fullURL, with: .encodable(self.mockData))
        self.stub(self.fullURL, with: .encodable(self.mockData))
        self.stub(self.fullURL, with: .encodable(self.mockData))
    }
    
    func testStubbingAllRequests() {
        self.stub(.allRequests, with: .encodable(self.mockData))
        
        self.request(url: self.fullURL, data: self.mockData)
        self.request(url: self.schemeOnlyURL, data: self.mockData)
        self.request(url: self.hostOnlyURL, data: self.mockData)
        self.request(url: self.pathOnlyURL, data: self.mockData)
        self.request(url: self.queryOnlyURL, data: self.mockData)
    }
    
    func testStubbingExactURLOnly() {
        self.stub(self.fullURL, with: .encodable(self.mockData))
        
        self.request(url: self.fullURL, data: self.mockData)
        self.request(url: self.schemeOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.hostOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.pathOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.queryOnlyURL, data: self.mockData, shouldFail: true)
    }
    
    func testStubbingHostOnly() {
        self.stub(self.hostOnlyURL, with: .encodable(self.mockData))
        
        self.request(url: self.fullURL, data: self.mockData)
        self.request(url: self.schemeOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.hostOnlyURL, data: self.mockData)
        self.request(url: self.pathOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.queryOnlyURL, data: self.mockData, shouldFail: true)
    }
    
    func testStubbingPathOnly() {
        self.stub(self.pathOnlyURL, with: .encodable(self.mockData))
        
        self.request(url: self.fullURL, data: self.mockData)
        self.request(url: self.schemeOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.hostOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.pathOnlyURL, data: self.mockData)
        self.request(url: self.queryOnlyURL, data: self.mockData, shouldFail: true)
    }
    
    func testStubbingGetFailsPostRequests() {
        self.stub(.get(self.fullURL), with: .encodable(self.mockData))
        
        let hasData = MockService.shared.hasStub(for: .post(self.fullURL))
        
        XCTAssertTrue(MockService.shared.hasStubs)
        XCTAssertFalse(hasData)
    }
    
    func testStubbingSchemeOnlyFails() {
        // Attempting to stub a scheme-only URL should not load any data into the MockService
        self.stub(self.schemeOnlyURL, with: .encodable(self.mockData))
        
        let hasData = MockService.shared.hasStub(for: self.schemeOnlyURL)
        
        XCTAssertFalse(MockService.shared.hasStubs)
        XCTAssertFalse(hasData)
    }
    
    func testStubbingQueryOnlyFails() {
        // Attempting to stub a query-only URL should not load any data into the MockService
        self.stub(self.queryOnlyURL, with: .encodable(self.mockData))
        
        let hasData = MockService.shared.hasStub(for: self.queryOnlyURL)
        
        XCTAssertFalse(MockService.shared.hasStubs)
        XCTAssertFalse(hasData)
    }
    
    private func request<T>(url: URLConvertible,
                            data: T,
                            shouldFail: Bool = false,
                            file: StaticString = #file,
                            line: UInt = #line) where T: Codable, T: Equatable {
        let expectation = self.expectation(description: "Requesting foo strings.")
        
        HTTPClient.mocked.request(url, method: .get) { (response: DataResponse<T, Error>) in
            defer {
                expectation.fulfill()
            }
            
            switch response.result {
            case let .success(value):
                if shouldFail {
                    XCTFail("Request succeeded, expected it to fail.", file: file, line: line)
                } else {
                    XCTAssertEqual(data, value, file: file, line: line)
                }
            case let .failure(error):
                if !shouldFail {
                    XCTFail("Error Error: \(error.localizedDescription))", file: file, line: line)
                }
            }
        }
        
        self.waitForExpectations(timeout: 5)
    }
    
    func testQueryParameterMatching() {
        let baseURLResponse: StubResponse = .encodable("Base URL Response")
        let rightResponse: StubResponse = .encodable("Right Response")
        // swiftlint:disable:next line_length
        let fullString = "api/v1/facilities/769/rates/?show_unavailable=true&session_uuid=DCAFF36A-A268-4FFB-9CAC-63963DF12374&starts=2018-06-06T12%3A30&search_text=&ends=2018-06-06T18%3A00&auto_extend=true&action_id=6EB2D9E2-90B0-4A09-A3BB-0A287F50B2C3&action=rebook_recent_reservations&segment_id=TESTING&include=facility%2Cfacility.operator_id%2Cfacility.supported_fee_types&search_id=158ED109-3F21-45E6-BA63-6A0999A8F69B"
        
        let base = "api/v1/facilities/769/rates/"
        
        self.stub(.get(base), with: baseURLResponse)
        self.stub(.get(fullString), with: rightResponse)
        // swiftlint:disable:next line_length
        let rearranged = "api/v1/facilities/769/rates/?show_unavailable=true&session_uuid=DCAFF36A-A268-4FFB-9CAC-63963DF12374&starts=2018-06-06T12%3A30&search_text=&auto_extend=true&action_id=6EB2D9E2-90B0-4A09-A3BB-0A287F50B2C3&action=rebook_recent_reservations&segment_id=TESTING&include=facility%2Cfacility.operator_id%2Cfacility.supported_fee_types&ends=2018-06-06T18%3A00&search_id=158ED109-3F21-45E6-BA63-6A0999A8F69B"
        
        let testResult = MockService.shared.getResponse(for: StubRequest.get(rearranged))
        print("1. \(String(data: testResult!.data!, encoding: .utf8))")
        XCTAssertNotNil(testResult?.data)
        XCTAssertEqual(testResult?.data, rightResponse.data)
    }
}
