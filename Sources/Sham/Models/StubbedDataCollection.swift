// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// An object that manages a collection of stubbed data.
public final class StubbedDataCollection: Codable {
    // MARK: Properties
    
    /// A dictionary of stubbed responses keyed by stubbed requests.
    private(set) var stubbedData = [StubRequest: StubResponse]()
    
    // MARK: Functions
    
    public init() {}
    
    // MARK: Stubbing
    
    /// Adds a response to the stub response collection.
    /// - Parameter request: The request to stub.
    /// - Parameter response: The response to return upon receiving the given request.
    public func stub(_ request: StubRequest, with response: StubResponse) {
        // Ensure that the URL is valid for stubbing
        guard request.isValidForStubbing else {
            // TODO: Throw error
            return
        }
        
        // If the request exists, print a log to verify
        if self.stubbedData.keys.contains(request) {
            self.log("Stubbed data already exists for request '\(request)'. Updating with new data.")
        }
        
        self.stubbedData[request] = response
    }
    
    /// Determines whether or not a matching request has been stubbed.
    /// - Parameter request: The request to match against stubbed requests.
    public func hasStub(for request: StubRequest) -> Bool {
        return self.getResponse(for: request) != nil
    }
    
    /// Returns the stubbed response that matches the request.
    /// Returns nil if there is no matching stubbed request found.
    /// - Parameter request: The request to match against stubbed requests.
    public func getResponse(for request: StubRequest) -> StubResponse? {
        self.log("Attempting to stub request: \(request.description)")
        
        // Check for a match with the exact URL.
        var response = self.stubbedData[request]
        
        switch request.validationRule {
        case .explicit:
            self.logResponse(response)
            return response
        case .allowMissingParameters:
            // If response had no exact match, we need to find the closest match.
            if response == nil {
                // Filter out stubs that can not mock this request.
                let availableStubs = self.stubbedData.filter {
                    $0.key.canMockData(for: request)
                }
                
                // With the given stubs, now compare based on parameter values.
                response = availableStubs.first {
                    $0.key.hasAllProvidedParameters(for: request)
                }?.value
            }
            
            self.logResponse(response)
            
            // Return the response
            return response
        }
    }
    
    // MARK: Utilities
    
    /// Clears all stubbed responses from the stub response collection.
    public func clearData() {
        self.stubbedData = [:]
    }
    
    private func logResponse(_ response: StubResponse?) {
        // Log response debugging information.
        if let stubResponse = response {
            self.log("Found stub response: \(stubResponse)")
        } else {
            self.log("No stub response found.")
        }
    }
    
    private func log(_ message: String) {
        print("[Sham] \(message)")
    }
}
