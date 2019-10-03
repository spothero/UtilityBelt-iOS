// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents an HTTP result that contains raw data.
public struct DataResult: HTTPResult {
    public let data: Data?
    public let response: HTTPURLResponse?
    public let status: HTTPResultStatus

    public init(data: Data?, response: HTTPURLResponse?, status: HTTPResultStatus) {
        self.data = data
        self.response = response
        self.status = status
    }
}
