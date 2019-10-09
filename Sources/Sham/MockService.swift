// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

/// A service which contains stub requests and stub responses for use with the MockURLProtocol.
public class MockService {
    // MARK: - Shared Instance
    
    /// The shared instance of the service.
    public static let shared = MockService()

    // MARK: - Properties
    
    /// The default bundle to use when loading data via Bundle resource paths.
    public var defaultBundle: Bundle = .main
    
    /// Whether or not the service should be intercepting and mocking all requests.
    /// If false, the service will throw an error when it receive a request it has no response for.
    public var isMockingAllRequests = true

    /// A dictionary of stub responses keyed by stub requests.
    private var stubResponses = [StubRequest: StubResponse]()

    /// Whether or not there are any stubbed response.
    public var isEmpty: Bool {
        return self.stubResponses.isEmpty
    }

    // MARK: - Methods

    /// Initializes a MockService.
    ///
    /// Because URLProtocol registration cannot take an instance of a URLProtocol object,
    /// using any instance of MockService other than the shared instance would cause problems.
    /// Until we think of a way to allow this, we're restricting this class to just a shared instance for now.
    private init() {}

    // MARK: Registration
    
    /// Registers the MockURLProtocol to URLProtocol.
    public func register() {
        // TODO: Add some capability of also setting up a URLSessionConfiguration via a register() method
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    // MARK: Stubbing
    
    /// Returns the stubbed response that matches the request.
    /// Returns nil if there is no matching stubbed request found.
    /// - Parameter request: The request to match against stubbed requests.
    public func getResponse(for request: StubRequest) -> StubResponse? {
        // Check for a match with the exact URL
        if let exactMatchResponse = self.stubResponses[request] {
            return exactMatchResponse
        }

        // Otherwise, find the most appropriate match
        let firstResponse = self.stubResponses.first { $0.key.canMockData(for: request) }

        return firstResponse?.value
    }
    
    /// Determines whether or not a matching request has been stubbed.
    /// - Parameter request: The request to match against stubbed requests.
    public func hasStub(for request: StubRequest) -> Bool {
        return self.getResponse(for: request) != nil
    }
    
    /// Determines whether or not the service can attempt to mock a given request.
    /// Returns true if the service is attempting to intercept and mock all requests.
    /// - Parameter request: The request to match against stubbed requests.
    public func canMockData(for request: StubRequest) -> Bool {
        return self.isMockingAllRequests || self.hasStub(for: request)
    }
    
    /// Adds a response to the stub response collection for the MockService.
    /// - Parameter request: The request to stub.
    /// - Parameter response: The response to return upon receiving the given request.
    public func stub(_ request: StubRequest, with response: StubResponse) {
        // Ensure that the URL is valid for stubbing
        guard request.isValidForStubbing else {
            // TODO: Throw error
            return
        }

        if self.stubResponses.contains(where: { $0.key == request }) {
            print("Stubbed data already exists for request '\(request)'. Updating with new data.")
        }

        self.stubResponses[request] = response
    }

    // MARK: URLRequest Convenience
    
    /// Returns a stubbed response if there is a stubbed request that matches.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to match against stubbed requests.
    public func getResponse(for urlRequest: URLRequestConvertible) -> StubResponse? {
        return self.getResponse(for: StubRequest(urlRequest: urlRequest))
    }
    
    /// Determines whether or not a matching request has been stubbed.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to match against stubbed requests.
    public func hasStub(for urlRequest: URLRequestConvertible) -> Bool {
        return self.getResponse(for: urlRequest) != nil
    }
    
    /// Determines whether or not the service can attempt to mock a given request.
    /// Returns true if the service is attempting to intercept and mock all requests.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to against stubbed requests.
    public func canMockData(for urlRequest: URLRequestConvertible) -> Bool {
        return self.isMockingAllRequests || self.hasStub(for: urlRequest)
    }
    
    /// Adds a response to the stub response collection.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to stub.
    /// - Parameter response: The response to return upon receiving the given request.
    public func stub(_ urlRequest: URLRequestConvertible, with response: StubResponse) {
        let request = StubRequest(urlRequest: urlRequest)
        return self.stub(request, with: response)
    }

    // MARK: Utilities
    
    /// Clears all stubbed responses from the stub response collection.
    public func clearData() {
        self.stubResponses = [:]
    }
}
