// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking
import XCTest

final class RequestTests: XCTestCase {
    // MARK: Request Adapting Tests
    
    func testAdaptedURLIsReturnedInDataResponse() throws {
        // Create an adapter that changes the original request.
        struct MockAdapter: RequestInterceptor {
            static let adaptedURL = "spothero.com/foo"
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
        
        // Create a request with the expectation the response includes the adapted url.
        let expectation = self.expectation(description: "Request has completed")
        let request = Request(session: .shared, interceptor: interceptor) { response in
            XCTAssertEqual(response.request?.url?.absoluteString, MockAdapter.adaptedURL)
            expectation.fulfill()
        }
        
        // Perform the request.
        let initialURL = "spothero.com"
        XCTAssertNotEqual(initialURL, MockAdapter.adaptedURL)
        request.perform(urlRequest: try self.urlRequest(url: "spothero.com"))
        
        // Verify the expectation is met.
        self.wait(for: [expectation], timeout: 1)
    }
    
    func testErrorDuringRequestAdaptingIsReturnedInDataResponse() throws {
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
        
        // Create a request with the expectation the response includes
        // the error that was returned by the adapter.
        let expectation = self.expectation(description: "Request has completed")
        let request = Request(session: .shared, interceptor: interceptor) { response in
            XCTAssertEqual(response.error?.localizedDescription,
                           MockAdapter.errorDescription)
            expectation.fulfill()
        }
        
        // Perform the request.
        request.perform(urlRequest: try self.urlRequest(url: "spothero.com"))
        
        // Verify the expectation is met.
        self.wait(for: [expectation], timeout: 1)
    }
    
    // MARK: Request Retrying Tests
    
    func testRetryCountIncreasesWhenRetryIsRequested() throws {
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
        
        // Perform the request.
        let request = Request(session: .shared, interceptor: interceptor) { _ in }
        request.perform(urlRequest: try self.urlRequest(url: "spothero.com"))
        
        // Verify that the retry expectation was called.
        self.wait(for: [retryExpectation], timeout: 1)
        
        // Verify the retryCount was incremented.
        XCTAssertEqual(request.retryCount, 1)
    }
}

// MARK: - Utilities

private extension RequestTests {
    func urlRequest(url: URLConvertible,
                    method: HTTPMethod = .get,
                    parameters: ParameterDictionaryConvertible? = nil,
                    headers: HTTPHeaderDictionaryConvertible? = nil,
                    encoding: ParameterEncoding? = nil,
                    timeout: TimeInterval? = 0.1) throws -> URLRequest {
        var request = try HTTPClient.shared.configuredURLRequest(url: url,
                                                                 method: method,
                                                                 parameters: parameters,
                                                                 headers: headers,
                                                                 encoding: encoding)
        
        if let timeout = timeout {
            request.timeoutInterval = timeout
        }
        
        return request
    }
}
