// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public extension URLSessionConfiguration {
    /// A URLSessionConfiguration set up to work with the MockService on top of the default settings.
    static var mocked: URLSessionConfiguration {
        let urlConfig: URLSessionConfiguration = .mocked
        urlConfig.protocolClasses = [MockURLProtocol.self]

        return urlConfig
    }
}
