// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents an HTTP result that contains a decoded object as its data.
public class DecodableResult<T>: HTTPResult where T: Decodable {
    public let data: T?
    public let error: Error?
    public let response: HTTPURLResponse?

    required public init(data: T?, response: HTTPURLResponse?, error: Error? = nil) {
        self.data = data
        self.error = error
        self.response = response
    }
    
    public static func errorResult<T>(_ error: Error) -> DecodableResult<T> {
        return DecodableResult<T>(data: nil, response: nil, error: error)
    }
}
