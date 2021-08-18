// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking
import XCTest

final class RequestInterceptorTests: XCTestCase {
    // MARK: Lifecycle
    
    override class func setUp() {
        super.setUp()
        // Set a short timeout to avoid waiting on requests to complete.
        HTTPClient.shared.timeoutInterval = 0.1
    }
    
    override class func tearDown() {
        // Reset the timeout interval.
        HTTPClient.shared.timeoutInterval = nil
        super.tearDown()
    }
    
    // MARK: RequestAdapter Tests
    
    func testAdaptedURLIsReturnedInDataResponse() {
        // Create an adapter that changes the original request.
        struct MockAdapter: RequestInterceptor {
            static let adaptedURL = "https//www.spothero.com/foo"
            func adapt(_ request: URLRequest,
                       completion: (Result<URLRequest, Error>) -> Void) {
                var adaptedRequest = request
                adaptedRequest.url = URL(string: Self.adaptedURL)
                completion(.success(adaptedRequest))
            }
            
            func retry(_ request: Request, dueTo error: Error, completion: (Bool) -> Void) {
                completion(false)
            }
        }
        
        let interceptor = MockAdapter()
        
        // Start a request for the initial URL.
        let expectation = self.expectation(description: "Request has completed")
        let initialURL = "https//www.spothero.com"
        HTTPClient.shared.request(initialURL, interceptor: interceptor) { response in
            // Verify the response returns the adapted URL.
            XCTAssertEqual(response.request?.url?.absoluteString, MockAdapter.adaptedURL)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testErrorDuringRequestAdaptingIsReturnedInDataResponse() {
        // Create an adapter that returns an error.
        struct MockAdapter: RequestInterceptor {
            static let errorDescription = "Adapting url failed"
            func adapt(_ request: URLRequest,
                       completion: (Result<URLRequest, Error>) -> Void) {
                let error = NSError(domain: "testing.domain",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: Self.errorDescription])
                completion(.failure(error))
            }
            
            func retry(_ request: Request, dueTo error: Error, completion: (Bool) -> Void) {
                completion(false)
            }
        }
        
        let interceptor = MockAdapter()
        
        // Start a request.
        let expectation = self.expectation(description: "Request has completed")
        let url = "https//www.spothero.com"
        HTTPClient.shared.request(url, interceptor: interceptor) { response in
            // Verify the response returns the error from the adapter.
            XCTAssertEqual(response.error?.localizedDescription,
                           MockAdapter.errorDescription)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 1)
    }
    
    // MARK: RequestRetrier Tests
    
    func testRetryCountIncreasesWhenRetryIsRequested() {
        // Create an interceptor that will trigger a retry once.
        class MockInterceptor: RequestInterceptor {
            func adapt(_ request: URLRequest, completion: (Result<URLRequest, Error>) -> Void) {
                completion(.success(request))
            }
            
            var retryExpectation: XCTestExpectation?
            func retry(_ request: Request, dueTo error: Error, completion: (Bool) -> Void) {
                if request.retryCount < 1 {
                    completion(true)
                    self.retryExpectation?.fulfill()
                } else {
                    completion(false)
                }
            }
        }
        
        let interceptor = MockInterceptor()
        
        // Set an expectation that retry will be invoked.
        let retryExpectation = self.expectation(description: "Retry was called")
        interceptor.retryExpectation = retryExpectation
        
        // Perform a request.
        HTTPClient.shared.request("spothero.com", interceptor: interceptor) { _ in }
        
        // Verify that the retry expectation was called once as the retryCount was incremented.
        self.wait(for: [retryExpectation], timeout: 1)
    }
}
