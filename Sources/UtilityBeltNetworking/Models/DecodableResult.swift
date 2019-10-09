// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents an HTTP result that contains a decoded object as its data.
public struct DecodableResult<T>: HTTPResult where T: Decodable {
    public let data: T?
    public let error: Error?
    public let response: HTTPURLResponse

    public init(data: T?, response: HTTPURLResponse, error: Error? = nil) {
        self.data = data
        self.error = error
        self.response = response
    }
}
