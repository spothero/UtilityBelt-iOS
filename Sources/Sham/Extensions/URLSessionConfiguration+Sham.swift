// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public extension URLSessionConfiguration {
    /// A URLSessionConfiguration set up to work with Sham's MockService on top of the default settings.
    static var sham: URLSessionConfiguration {
        let urlConfig: URLSessionConfiguration = .default
        urlConfig.protocolClasses = [MockURLProtocol.self]

        return urlConfig
    }
}
