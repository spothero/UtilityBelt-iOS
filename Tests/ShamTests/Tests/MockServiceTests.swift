
@testable import Sham
import UtilityBeltNetworking
import XCTest

final class MockServiceTests: XCTestCase {
    let fullURL: URL = "https://foo.com/foo?foo=bar"
    let schemeOnlyURL: URL = "https://"
    let hostOnlyURL: URL = "//foo.com"
    let pathOnlyURL: URL = "/foo"
    let queryOnlyURL: URL = "?foo=bar"
    
    let mockData = ["foo", "bar"]
    
    override func setUp() {
        super.setUp()
        
//        MockService.shared.stub("spots", object: Spot.mockList)
    }
    
    override func tearDown() {
        MockService.shared.clearData()
    }
    
    func testStubbingSameURL() {
        MockService.shared.stub(self.fullURL, object: self.mockData)
        MockService.shared.stub(self.fullURL, object: self.mockData)
        MockService.shared.stub(self.fullURL, object: self.mockData)
    }
    
    func testStubbingExactURLOnly() {
        MockService.shared.stub(self.fullURL, object: self.mockData)
        
        self.request(url: self.fullURL, data: self.mockData)
        self.request(url: self.schemeOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.hostOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.pathOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.queryOnlyURL, data: self.mockData, shouldFail: true)
    }
    
    func testStubbingHostOnly() {
        MockService.shared.stub(self.hostOnlyURL, object: self.mockData)
        
        self.request(url: self.fullURL, data: self.mockData)
        self.request(url: self.schemeOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.hostOnlyURL, data: self.mockData)
        self.request(url: self.pathOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.queryOnlyURL, data: self.mockData, shouldFail: true)
    }
    
    func testStubbingPathOnly() {
        MockService.shared.stub(self.pathOnlyURL, object: self.mockData)
        
        self.request(url: self.fullURL, data: self.mockData)
        self.request(url: self.schemeOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.hostOnlyURL, data: self.mockData, shouldFail: true)
        self.request(url: self.pathOnlyURL, data: self.mockData)
        self.request(url: self.queryOnlyURL, data: self.mockData, shouldFail: true)
    }
    
    func testStubbingSchemeOnlyFails() {
        MockService.shared.stub(self.schemeOnlyURL, object: self.mockData)
        
        let hasData = MockService.shared.hasData(for: self.schemeOnlyURL)
        
        XCTAssertTrue(MockService.shared.isEmpty)
        XCTAssertFalse(hasData)
    }
    
    func testStubbingQueryOnlyFails() {
        MockService.shared.stub(self.queryOnlyURL, object: self.mockData)
        
        let hasData = MockService.shared.hasData(for: self.queryOnlyURL)
        
        XCTAssertTrue(MockService.shared.isEmpty)
        XCTAssertFalse(hasData)
    }
    
//    func testMockService() {
//        let client = HTTPClient.shared
//
//        client.request("spots", method: .get) { (result: DecodableResult<[Spot]>) in
//            let spots = result.data
//
//
//            print(spots)
//        }
//    }
    
    private func request<T>(url: URL, data: T, shouldFail: Bool = false, file: StaticString = #file, line: UInt = #line) where T : Codable, T : Equatable {
        let expectation = self.expectation(description: "Requesting foo strings.")
        
        HTTPClient.shared.request(url, method: .get) { (result: DecodableResult<T>) in
            defer {
                expectation.fulfill()
            }
            
            XCTAssertEqual(shouldFail, !result.success)
            
            if shouldFail {
                XCTAssertNil(result.data, file: file, line: line)
            } else {
                XCTAssertEqual(data, result.data, file: file, line: line)
            }
            
//            guard let strings = result.data else {
//                XCTFail("No data returned!")
//                return
//            }
//
//            XCTAssertTrue(result.success)
//            XCTAssertEqual(strings.count, 2)
//            XCTAssertEqual(strings[0], "foo")
//            XCTAssertEqual(strings[1], "bar")
        }
        
        self.waitForExpectations(timeout: 15)
    }
}
