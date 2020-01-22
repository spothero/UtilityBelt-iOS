// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public extension URLSession {
    /// A URLSession set up to work with the MockService on top of the default settings.
    static var mocked: URLSession {
        return URLSession(configuration: .mocked)
    }
}
