// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// An object that can be injected into the launch environment to set up the mocking information.
public final class LaunchEnvironmentMockData: Codable {
    enum Errors: Error {
        case invalidStubRequest
    }
    
    // MARK: Properties
    
    private(set) var stubbedData = [StubRequest: StubResponse]()
    
    // MARK: Functions
    
    public init() {}
    
    /// Verifies and sets the stubbing requests on the mocked data launch environment object.
    /// - Parameters:
    ///   - stubRequest: The request to stub.
    ///   - response: The response to return.
    /// - Throws: Throws an error if the stub is invalid.
    public func stub(_ stubRequest: StubRequest, with response: StubResponse) throws {
        guard stubRequest.isValidForStubbing else {
            throw Errors.invalidStubRequest
        }
        self.stubbedData[stubRequest] = response
    }
}

// MARK: - Extensions

// MARK: - LaunchEnvironmentObject

extension LaunchEnvironmentMockData: LaunchEnvironmentObject {
    /// The key used to save and retrieve the object in the launch environment.
    public static var launchEnvironmentKey = "mocked-data"
    // The encoded value of the object in String form, throws an error if unable to encode.
    public func encodedStringValue() throws -> String? {
        let encodedValue = try JSONEncoder().encode(self)
        return String(data: encodedValue, encoding: .utf8)
    }
}
