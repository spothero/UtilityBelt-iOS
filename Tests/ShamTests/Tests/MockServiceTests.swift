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
}
