// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents an HTTP result that contains raw data.
public class DataResult: HTTPResult {
    public let data: Data?
    public let error: Error?
    public let response: HTTPURLResponse?
    
    required public init(data: Data?, response: HTTPURLResponse?, error: Error? = nil) {
        self.data = data
        self.error = error
        self.response = response
    }
    
    public static func errorResult(_ error: Error) -> DataResult {
        return DataResult(data: nil, response: nil, error: error)
    }
}
