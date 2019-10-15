// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents an HTTP result that contains raw data.
public struct DataResult: HTTPResult {
    public let data: Data?
    public let error: Error?
    public let response: HTTPURLResponse?

    public init(data: Data?, response: HTTPURLResponse?, error: Error? = nil) {
        self.data = data
        self.error = error
        self.response = response
    }
}
