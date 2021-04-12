// Copyright © 2021 SpotHero, Inc. All rights reserved.

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
    
    /// Whether or not the service should be logging mock requests.
    public var isDebugLoggingEnabled: Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
    
    /// A dictionary of stubbed responses keyed by stubbed requests.
    private var stubbedDataCollection = StubbedDataCollection()
    
    /// Whether or not there are any stubbed response.
    public var hasStubs: Bool {
        return !self.stubbedDataCollection.stubbedData.isEmpty
    }
    
    // MARK: - Methods
    
    /// Initializes a MockService.
    ///
    /// Because URLProtocol registration cannot take an instance of a URLProtocol object,
    /// using any instance of MockService other than the shared instance would cause problems.
    /// Until we think of a way to allow this, we're restricting this class to just a shared instance for now.
    private init() {}
    
    // MARK: Registration
    
    /// Globally registers the MockURLProtocol to URLProtocol.
    ///
    /// This doesn't work for all clients (eg. Alamofire), so in some cases we'll need to add the protocol
    /// into a URLSessionConfiguration and build a URLSession from that instead.
    public func register() {
        // TODO: Add some capability of also setting up a URLSessionConfiguration via a register() method
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    /// Globally unregisters the MockURLProtocol from URLProtocol.
    public func unregister() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    // MARK: Stubbing
    
    /// Clears the current stub information and updates to use the information on the passed in collection.
    /// - Parameter collection: The collection to use.
    public func updateStubbedData(withCollection collection: StubbedDataCollection) {
        self.clearData()
        collection.stubbedData.forEach { request, response in
            self.stub(request, with: response)
        }
    }
    
    /// Determines whether or not the service can attempt to mock a given request.
    /// Returns true if the service is attempting to intercept and mock all requests.
    /// - Parameter request: The request to match against stubbed requests.
    public func canMockData(for request: StubRequest) -> Bool {
        return self.isMockingAllRequests || self.stubbedDataCollection.hasStub(for: request)
    }
    
    // MARK: URLRequest Convenience
    
    /// Determines whether or not the service can attempt to mock a given request.
    /// Returns true if the service is attempting to intercept and mock all requests.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to against stubbed requests.
    public func canMockData(for urlRequest: URLRequestConvertible) -> Bool {
        let request = StubRequest(urlRequest: urlRequest)
        return self.canMockData(for: request)
    }
    
    /// Adds a response to the stub response collection.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to stub.
    /// - Parameter response: The response to return upon receiving the given request.
    public func stub(_ urlRequest: URLRequestConvertible, with response: StubResponse) {
        let request = StubRequest(urlRequest: urlRequest)
        return self.stubbedDataCollection.stub(request, with: response)
    }
    
    // MARK: Utilities
    
    /// Clears all stubbed responses from the stub response collection.
    public func clearData() {
        self.stubbedDataCollection.clearData()
    }
    
    private func log(_ message: String) {
        guard self.isDebugLoggingEnabled else {
            return
        }
        
        print("[Sham] \(message)")
    }
}
