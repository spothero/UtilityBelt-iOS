// Copyright © 2023 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking
import XCTest

final class RequestTests: XCTestCase, URLRequesting {
    // MARK: State Tests
    
    func testRequestIsNotRunningUponInitialization() {
        // Initialize a new Request object.
        let request = Request(session: .shared)
        
        // Verify the Request is not running.
        XCTAssertFalse(request.isRunning)
    }
    
    func testRequestIsNotRunningAfterCompletionBlockIsCalled() throws {
        // Initialize a new Request object.
        let expectation = self.expectation(description: "Request completed")
        let request = Request(session: .shared) { _ in
            expectation.fulfill()
        }
        
        // Perform the request.
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
        // Wait on the request to complete.
        self.wait(for: [expectation], timeout: 1)
        
        // Verify the Request it no longer running when completed.
        XCTAssertFalse(request.isRunning)
    }
    
    func testRequestIsRunningWhenAdaptingPriorToInitialSessionTaskStarting() throws {
        // Create an interceptor that will adapt the request.
        class MockInterceptor: RequestInterceptor {
            var adaptationBeganExpectation: XCTestExpectation?
            
            func adapt(_ request: URLRequest, completion: @escaping (Result<URLRequest, Error>) -> Void) {
                self.adaptationBeganExpectation?.fulfill()
                
                // Delay calling the completion block for 1 second to ensure
                // we can check the status of the Request while adapting.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    completion(.success(request))
                }
            }
            
            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: (Bool) -> Void) {
                completion(false)
            }
        }
        
        let interceptor = MockInterceptor()
        
        // Set an expectation for when request adaptation begins.
        let expectation = self.expectation(description: "Starting RequestAdapter")
        interceptor.adaptationBeganExpectation = expectation
        
        // Start the Request.
        let request = Request(session: .shared, interceptor: interceptor)
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
        // Wait for the signal that request adaptation has begun.
        self.wait(for: [expectation], timeout: 1)
        
        // Verify the Request is running.
        XCTAssertTrue(request.isRunning)
    }
    
    func testRequestIsRunningWhenRequestRetrierIsRunningAfterInitialTaskHasCompleted() throws {
        // Create an interceptor that will retry the request.
        class MockInterceptor: RequestInterceptor {
            func adapt(_ request: URLRequest, completion: @escaping (Result<URLRequest, Error>) -> Void) {
                completion(.success(request))
            }

            var selectors = [String]()
            var retryBeganExpectation: XCTestExpectation?
            
            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: @escaping (Bool) -> Void) {
                guard request.retryCount < 1 else {
                    completion(false)
                    return
                }
                
                self.retryBeganExpectation?.fulfill()
                
                // Delay calling the completion block for 1 second to ensure the
                // cancellation request is received prior to the retrier finishing.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    completion(true)
                }
            }

            func requestWillStart(_ request: Request) {
                selectors.append(#function)
            }

            func requestDidEnd(_ request: Request) {
                selectors.append(#function)
            }
        }
        
        let interceptor = MockInterceptor()
        // Set an expectation for when the RequestRetrier begins.
        let expectation = self.expectation(description: "Starting RequestRetrier")
        interceptor.retryBeganExpectation = expectation
        
        // Perform the Request.
        let request = Request(session: .shared, interceptor: interceptor)
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
        // Wait for the RequestRetrier to start.
        self.wait(for: [expectation], timeout: 1)
        
        // Verify the Request is running.
        XCTAssertTrue(request.isRunning)

        XCTAssertEqual(interceptor.selectors, ["requestWillStart(_:)"])
    }
    
    // MARK: Request Adapting Tests
    
    func testAdaptedURLIsReturnedInDataResponse() throws {
        // Create an adapter that changes the original request.
        struct MockAdapter: RequestInterceptor {
            static let adaptedURL = "https://spothero.com/foo"
            
            func adapt(_ request: URLRequest,
                       completion: (Result<URLRequest, Error>) -> Void) {
                var adaptedRequest = request
                adaptedRequest.url = URL(string: Self.adaptedURL)
                completion(.success(adaptedRequest))
            }
            
            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: (Bool) -> Void) {
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
        let initialURL = "https://spothero.com"
        XCTAssertNotEqual(initialURL, MockAdapter.adaptedURL)
        try request.perform(urlRequest: self.urlRequest(url: initialURL))
        
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
            
            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: (Bool) -> Void) {
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
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
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
            
            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: (Bool) -> Void) {
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
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
        // Verify that the retry expectation was called.
        self.wait(for: [retryExpectation], timeout: 1)
        
        // Verify the retryCount was incremented.
        XCTAssertEqual(request.retryCount, 1)
    }
    
    func testRequestCompletionIsOnlyInvokedOnceWhenRequestingRetry() throws {
        // Create an interceptor that will trigger a retry multiple times.
        class MockInterceptor: RequestInterceptor {
            func adapt(_ request: URLRequest, completion: (Result<URLRequest, Error>) -> Void) {
                completion(.success(request))
            }
            
            var retryExpectation: XCTestExpectation?
            var selectors = [String]()

            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: (Bool) -> Void) {
                if request.retryCount < 3 {
                    completion(true)
                    self.retryExpectation?.fulfill()
                } else {
                    completion(false)
                }
            }

            func requestWillStart(_ request: Request) {
                selectors.append(#function)
            }

            func requestDidEnd(_ request: Request) {
                selectors.append(#function)
            }
        }
        
        let interceptor = MockInterceptor()
        
        // Set an expectation that retry will be invoked 3 times.
        let retryExpectation = self.expectation(description: "Retry was called")
        retryExpectation.expectedFulfillmentCount = 3
        interceptor.retryExpectation = retryExpectation
        
        // Perform a request.
        let requestExpectation = self.expectation(description: "Request completed")
        let request = Request(session: .shared, interceptor: interceptor) { _ in
            requestExpectation.fulfill()
        }
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
        // Verify retry occurred multiple times yet the request completion was only invoked once.
        self.wait(for: [retryExpectation, requestExpectation], timeout: 2)

        XCTAssertEqual(interceptor.selectors, ["requestWillStart(_:)", "requestDidEnd(_:)"])
    }
    
    // MARK: Cancelling Tests
    
    func testCancellingARequestWhileRequestAdapterIsRunningProducesCancellationError() throws {
        // Create an interceptor that will adapt the request.
        class MockInterceptor: RequestInterceptor {
            var selectors = [String]()

            func adapt(_ request: URLRequest, completion: @escaping (Result<URLRequest, Error>) -> Void) {
                // Delay calling the completion block for 1 second to ensure the
                // cancellation request is received prior to the adapter finishing.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    completion(.success(request))
                }
            }
            
            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: (Bool) -> Void) {
                completion(false)
            }

            func requestWillStart(_ request: Request) {
                selectors.append(#function)
            }

            func requestDidEnd(_ request: Request) {
                selectors.append(#function)
            }
        }
        
        let interceptor = MockInterceptor()
        
        // Start the request.
        let requestExpectation = self.expectation(description: "Request completed")
        let request = Request(session: .shared, interceptor: interceptor) { response in
            // Verify we received a cancellation error after the adapter completed.
            guard let error = response.error else {
                XCTFail("Response error should not be nil")
                return
            }
            
            XCTAssertEqual((error as NSError).domain, NSURLErrorDomain)
            XCTAssertEqual((error as NSError).code, NSURLErrorCancelled)
            
            requestExpectation.fulfill()
        }
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
        // Cancel the request while the adapter is running.
        request.cancel()
        
        self.wait(for: [requestExpectation], timeout: 2)

        XCTAssertEqual(interceptor.selectors, ["requestWillStart(_:)", "requestDidEnd(_:)"])
    }
    
    func testCancellingARequestWhileRequestRetrierIsRunningProducesCancellationError() throws {
        // Create an interceptor that will retry the request.
        class MockInterceptor: RequestInterceptor {
            func adapt(_ request: URLRequest, completion: @escaping (Result<URLRequest, Error>) -> Void) {
                completion(.success(request))
            }
            
            var asyncRetryOperationStartedExpectation: XCTestExpectation?
            
            func retry(_ request: Request, dueTo error: Error, data: Data?, completion: @escaping (Bool) -> Void) {
                guard request.retryCount < 1 else {
                    completion(false)
                    return
                }
                
                self.asyncRetryOperationStartedExpectation?.fulfill()
                
                // Delay calling the completion block for 1 second to ensure the
                // cancellation request is received prior to the retrier finishing.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    completion(true)
                }
            }
        }
        
        let interceptor = MockInterceptor()
        
        // Create a request.
        let requestExpectation = self.expectation(description: "Request completed")
        let request = Request(session: .shared, interceptor: interceptor) { response in
            // Verify we received a cancellation error after the adapter completed.
            guard let error = response.error else {
                XCTFail("Response error should not be nil")
                return
            }
            
            XCTAssertEqual((error as NSError).domain, NSURLErrorDomain)
            XCTAssertEqual((error as NSError).code, NSURLErrorCancelled)
            
            requestExpectation.fulfill()
        }
        
        // Set an expectation for when the RequestRetrier begins.
        let requestRetrierStartedExpectation = self.expectation(description: "Starting RequestRetrier")
        interceptor.asyncRetryOperationStartedExpectation = requestRetrierStartedExpectation
        
        // Perform the request.
        try request.perform(urlRequest: self.urlRequest(url: "https://spothero.com"))
        
        // Wait for the RequestRetrier to start.
        self.wait(for: [requestRetrierStartedExpectation], timeout: 1)
        
        // Cancel the request while the retrier is running.
        request.cancel()
        
        // Wait for the request to complete.
        self.wait(for: [requestExpectation], timeout: 2)
    }
}
