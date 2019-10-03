// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents an HTTP result that contains a decoded object as its data.
public struct DecodableResult<T>: HTTPResult where T: Decodable {
    public let data: T?
    public let response: HTTPURLResponse?
    public let status: HTTPResultStatus

    public init(data: T?, response: HTTPURLResponse?, status: HTTPResultStatus) {
        self.data = data
        self.response = response
        self.status = status
    }
}
