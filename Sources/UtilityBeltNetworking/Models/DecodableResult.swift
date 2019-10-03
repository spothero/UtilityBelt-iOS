// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public struct DecodableResult<T>: HTTPResult where T: Decodable {
    public let data: T?
    public let response: URLResponse?
    public let status: HTTPResultStatus

    public init(data: T?, response: URLResponse?, status: HTTPResultStatus) {
        self.data = data
        self.response = response
        self.status = status
    }
}
