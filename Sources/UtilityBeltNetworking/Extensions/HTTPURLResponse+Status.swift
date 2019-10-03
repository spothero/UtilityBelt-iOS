// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public extension HTTPURLResponse {
    /// The enum-based HTTP status code.
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: self.statusCode)
    }
}
