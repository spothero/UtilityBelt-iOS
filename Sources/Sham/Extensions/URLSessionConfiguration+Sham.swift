// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public extension URLSessionConfiguration {
    static var sham: URLSessionConfiguration {
        let urlConfig: URLSessionConfiguration = .default
        urlConfig.protocolClasses = [MockURLProtocol.self]

        return urlConfig
    }
}
